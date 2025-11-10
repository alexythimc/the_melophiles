import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:the_melophiles/models/song_model.dart';

/// ✅ Artist Image Helper Service
class ArtistImageService {
  static const _lastFmKey =
      '7265bf03d8d6a0985b0dced75fd936fb'; // 🔑 Replace this
  static const _unsplashKey = 'YOUR_UNSPLASH_ACCESS_KEY'; // 🔑 Replace this

  /// Fetch artist image from Last.fm → fallback to Unsplash → cache in Hive
  static Future<String?> fetchArtistImage(String artistName) async {
    final cacheBox = await Hive.openBox('artist_images');
    if (cacheBox.containsKey(artistName)) {
      return cacheBox.get(artistName);
    }

    String? imageUrl = await _fetchFromDeezer(artistName);
    // imageUrl ??= await _fetchFromUnsplash(artistName);

    if (imageUrl != null && imageUrl.isNotEmpty) {
      await cacheBox.put(artistName, imageUrl);
    }

    return imageUrl;
  }

  static Future<String?> _fetchFromLastFm(String artist) async {
    try {
      final url = Uri.parse(
        'https://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=${Uri.encodeComponent(artist)}&api_key=7265bf03d8d6a0985b0dced75fd936fb&format=json',
      );

      final res = await http.get(
        url,
        headers: {
          'User-Agent': 'the_melophiles_app/1.0 (https://themelophiles.com)',
        },
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        // Try to find image array safely
        final images = data['artist']?['image'];
        if (images != null && images is List && images.isNotEmpty) {
          // Prefer "mega" or "extralarge" size
          for (final img in images.reversed) {
            final url = img['#text'];
            if (url != null && url.toString().isNotEmpty) {
              return url;
            }
          }
        } else {
          print('No images found for artist: $artist');
        }
      } else {
        print('Last.fm API failed: ${res.statusCode}');
        print('Response: ${res.body}');
      }
    } catch (e) {
      print('Error fetching from Last.fm: $e');
    }
    return null;
  }

  static Future<String?> _fetchFromDeezer(String artist) async {
    try {
      final url = Uri.parse(
        'https://api.deezer.com/search/artist?q=${Uri.encodeComponent(artist)}',
      );
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          return data['data'][0]['picture_big'];
        }
      }
    } catch (e) {
      print('Deezer fetch failed: $e');
    }
    return null;
  }

  static Future<String?> _fetchFromUnsplash(String artist) async {
    try {
      final url = Uri.parse(
        'https://api.unsplash.com/search/photos?query=$artist%20singer&client_id=$_unsplashKey&per_page=1',
      );
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final results = data['results'];
        if (results != null && results.isNotEmpty) {
          return results[0]['urls']['regular'];
        }
      }
    } catch (_) {}
    return null;
  }
}

/// ✅ ARTIST PARSER & DEDUPLICATION ENGINE
class ArtistProcessor {
  /// Parse artist string and extract individual artists
  static List<String> parseArtists(String artistString) {
    if (artistString.isEmpty) return ['Unknown Artist'];

    // Common separators for collaborations
    final separators = ['feat.', 'ft.', 'featuring', '&', 'with', ',', 'x '];
    String processed = artistString.toLowerCase();

    for (final sep in separators) {
      processed = processed.replaceAll(sep, '|');
    }

    return processed
        .split('|')
        .map((a) => a.trim())
        .where((a) => a.isNotEmpty)
        .toList();
  }

  /// Normalize artist name (remove special chars, lowercase)
  static String normalizeArtist(String artist) {
    return artist.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').trim();
  }

  /// Check if two artist names are the same (fuzzy matching)
  static bool isSameArtist(String artist1, String artist2) {
    final norm1 = normalizeArtist(artist1);
    final norm2 = normalizeArtist(artist2);

    if (norm1 == norm2) return true;

    // Check if one contains the other (handles "Taylor Swift" vs "Taylor")
    if (norm1.contains(norm2) || norm2.contains(norm1)) {
      final diff = (norm1.length - norm2.length).abs();
      return diff <= 2; // Allow small differences
    }

    return false;
  }

  /// Build deduplicated artist map from songs
  static Map<String, ArtistData> buildArtistMap(List<Song> songs) {
    final artistMap = <String, ArtistData>{};

    for (final song in songs) {
      final artists = parseArtists(song.artist);

      for (final artist in artists) {
        if (artist.isEmpty) continue;

        // Find if this artist already exists (fuzzy match)
        String? existingKey;
        for (final key in artistMap.keys) {
          if (isSameArtist(artist, key)) {
            existingKey = key;
            break;
          }
        }

        if (existingKey != null) {
          // Add to existing artist
          artistMap[existingKey]!.songs.add(song);
          if (artists.length > 1) {
            artistMap[existingKey]!.collaborations.add(song);
          }
        } else {
          // Create new artist
          final isFeature = artists.length > 1;
          artistMap[artist] = ArtistData(
            name: artist,
            songs: [song],
            collaborations: isFeature ? [song] : [],
          );
        }
      }
    }

    return artistMap;
  }
}

/// ✅ ARTIST DATA MODEL
class ArtistData {
  final String name;
  final List<Song> songs;
  final String? image;
  final List<Song> collaborations;

  ArtistData({
    required this.name,
    required this.songs,
    required this.collaborations,
    this.image,
  });

  int get soloCount => songs.length - collaborations.length;
  int get featCount => collaborations.length;
  int get totalCount => songs.length;

  String get displayStats {
    if (soloCount == 0) {
      return '$featCount features';
    } else if (featCount == 0) {
      return '$soloCount tracks';
    } else {
      return '$soloCount + $featCount feat';
    }
  }
}

/// ---------------------------------------------------------------
///  MINIMALIST ARTIST PAGE – Main Hub with Smart Deduplication
/// ---------------------------------------------------------------
class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  late List<ArtistData> artistList;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAndProcessArtists();
  }

  void _loadAndProcessArtists() {
    final songsBox = Hive.box('songs');
    final List<Song> allSongs = songsBox.values
        .whereType<Map>()
        .map((m) => Song.fromMap(Map<String, dynamic>.from(m)))
        .toList();

    // Use smart deduplication
    final artistMap = ArtistProcessor.buildArtistMap(allSongs);
    artistList = artistMap.values.toList()
      ..sort(
        (a, b) => b.totalCount.compareTo(a.totalCount),
      ); // Sort by popularity
  }

  @override
  Widget build(BuildContext context) {
    if (artistList.isEmpty) {
      return const Scaffold(body: Center(child: Text('No artists found')));
    }

    final selectedArtist = artistList[_selectedIndex];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ────────────── TOP HEADER ──────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),

            // ────────────── ARTISTS GRID ──────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MasonryView(
                  listOfItem: artistList,
                  numberOfColumn: 2,
                  itemBuilder: (artist) {
                    final idx = artistList.indexOf(artist as ArtistData);
                    final isSelected = idx == _selectedIndex;
                    final height = 180.0 + (idx % 3) * 40.0;

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedIndex = idx);
                      },
                      child: SizedBox(
                        height: height,
                        child: _ArtistGridCard(
                          artist: artist as ArtistData,
                          isSelected: isSelected,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (ctx, anim, secAnim) =>
                                    ArtistDetailPage(
                                      artistData: artist as ArtistData,
                                    ),
                                transitionsBuilder:
                                    (ctx, anim, secAnim, child) =>
                                        SlideTransition(
                                          position:
                                              Tween<Offset>(
                                                begin: const Offset(1, 0),
                                                end: Offset.zero,
                                              ).animate(
                                                CurvedAnimation(
                                                  parent: anim,
                                                  curve: Curves.easeOutCubic,
                                                ),
                                              ),
                                          child: child,
                                        ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ────────────── QUICK PREVIEW ──────────────
            if (selectedArtist.songs.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedArtist.name,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            selectedArtist.displayStats,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
//  ARTIST GRID CARD – Enhanced
// ────────────────────────────────────────────────────────────────
class _ArtistGridCard extends StatefulWidget {
  final ArtistData artist;
  final bool isSelected;
  final VoidCallback onTap;

  const _ArtistGridCard({
    required this.artist,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ArtistGridCard> createState() => _ArtistGridCardState();
}

class _ArtistGridCardState extends State<_ArtistGridCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: Tween<double>(begin: 1, end: 1.05).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOut,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.withOpacity(0.2),
                width: widget.isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (_isHovered || widget.isSelected)
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: Column(
              children: [
                // Image placeholder area
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.08),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                          widget.artist.image ??
                              'assets/images/artist_placeholder.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Text content
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.artist.name,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${widget.artist.totalCount}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────
///  ARTIST DETAIL PAGE – Reorganized for clarity
/// ────────────────────────────────────────────────────────────────
class ArtistDetailPage extends StatelessWidget {
  final ArtistData artistData;

  const ArtistDetailPage({super.key, required this.artistData});

  @override
  Widget build(BuildContext context) {
    final heroSong = artistData.songs.first;
    final soloTracks = artistData.songs
        .where((s) => !artistData.collaborations.contains(s))
        .toList();
    final featTracks = artistData.collaborations;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ────────────────────── HERO CARD ──────────────────────
            _HeroArtistCard(
              artistName: artistData.name,
              songTitle: heroSong.title,
              stats: artistData.displayStats,
              onPlay: () {
                // TODO: play heroSong
              },
            ),

            const SizedBox(height: 24),

            // ────────────────── TABS ───────────────────
            Expanded(
              child: DefaultTabController(
                length: soloTracks.isNotEmpty && featTracks.isNotEmpty ? 2 : 1,
                child: Column(
                  children: [
                    if (soloTracks.isNotEmpty && featTracks.isNotEmpty)
                      TabBar(
                        tabs: [
                          Tab(text: 'Solo (${soloTracks.length})'),
                          Tab(text: 'Features (${featTracks.length})'),
                        ],
                      ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          if (soloTracks.isNotEmpty)
                            ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: soloTracks.length,
                              itemBuilder: (ctx, i) => _RecommendedTrackCard(
                                song: soloTracks[i],
                                onTap: () {},
                              ),
                            )
                          else
                            const Center(child: Text('No solo tracks')),
                          if (featTracks.isNotEmpty)
                            ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: featTracks.length,
                              itemBuilder: (ctx, i) => _RecommendedTrackCard(
                                song: featTracks[i],
                                onTap: () {},
                              ),
                            )
                          else
                            const Center(child: Text('No features')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
//  HERO CARD
// ────────────────────────────────────────────────────────────────
class _HeroArtistCard extends StatelessWidget {
  final String artistName;
  final String songTitle;
  final String stats;
  final VoidCallback onPlay;

  const _HeroArtistCard({
    required this.artistName,
    required this.songTitle,
    required this.stats,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Positioned.fill(
            child: Material(
              borderRadius: BorderRadius.circular(24),
              elevation: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.surface.withOpacity(0.4),
                      Theme.of(context).colorScheme.surface.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -20,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    artistName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stats,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onPlay,
                    icon: const Icon(Icons.play_arrow, size: 20),
                    label: const Text('Play'),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
//  TRACK CARD
// ────────────────────────────────────────────────────────────────
class _RecommendedTrackCard extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;

  const _RecommendedTrackCard({required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.music_note, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      song.artist,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
