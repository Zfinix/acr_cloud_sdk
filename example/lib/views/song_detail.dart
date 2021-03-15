import 'package:acr_cloud_sdk_example/core/models/deezer_song_model.dart';
import 'package:acr_cloud_sdk_example/utils/margin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SongDetailPage extends StatelessWidget {
  final DeezerSongModel? songModel;
  const SongDetailPage([this.songModel]);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Material(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Color(0xffEDEDED),
                      borderRadius: BorderRadius.circular(10),
                      image: songModel != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                songModel?.album?.coverMedium ?? '',
                              ),
                            )
                          : null),
                ),
                const XMargin(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: context.screenWidth(0.42),
                      child: Text(
                        songModel?.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const YMargin(10),
                    Text(
                      songModel?.artist?.name ?? '',
                      style: GoogleFonts.montserrat(
                        color: Color(0xff727272),
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const YMargin(5),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            '${songModel?.album?.title ?? ''}',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: Color(0xffA3A3A3),
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            ' • ${DateTime.parse(songModel?.releaseDate ?? DateTime.now().toIso8601String()).year}',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: Color(0xffA3A3A3),
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Image.asset(
                  "assets/images/more.png",
                  height: 20,
                ),
                const XMargin(30),
              ],
            )
          ],
        ),
      ),
    );
  }
}
