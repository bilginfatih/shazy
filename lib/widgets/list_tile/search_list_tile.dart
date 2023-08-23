import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

class SearchListTile extends Padding {
  SearchListTile({
    Key? key,
    required String text1,
    required String text2,
    required String text3,
    required BuildContext context,
  }) : super(
          key: key,
          padding: EdgeInsets.only(
            bottom: context.responsiveHeight(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: context.responsiveHeight(4)),
                child: SvgPicture.asset(
                  'assets/svg/clock_2.svg',
                  colorFilter: ColorFilter.mode(
                      context.isLight ? Colors.black : Colors.white,
                      BlendMode.srcIn),
                ),
              ),
              SizedBox(
                width: context.responsiveWidth(10),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text1,
                    style: context.textStyle.subheadLargeMedium.copyWith(
                      color: HexColor(
                        context.isLight ? '#5A5A5A' : '#D0D0D0',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: context.responsiveWidth(270),
                    child: Text(
                      text2,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: context.textStyle.bodySmallRegular
                          .copyWith(color: HexColor('#B8B8B8')),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                text3,
                style: context.textStyle.subheadSmallRegular.copyWith(
                  color: HexColor(
                    context.isLight ? '#5A5A5A' : '#D0D0D0',
                  ),
                ),
              ),
            ],
          ),
        );
}
