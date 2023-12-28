import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/utils/assets.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/common_codes.dart';
import 'package:weather_app/utils/size_config.dart';
import 'package:weather_app/utils/strings.dart';
import 'package:weather_app/utils/text_style.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Forecastday> weatherData =
        ModalRoute.of(context)?.settings.arguments as List<Forecastday>;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: label(AppStrings.forecasts),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 600.setHeight(),
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 170.setHeight()),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16.setHeight()),
                        itemCount: 7,
                        itemBuilder: (context, index) => forecastItem(
                          minTemp: weatherData[index].day?.mintempC?.toInt(),
                          maxTemp: weatherData[index].day?.maxtempC?.toInt(),
                          weatherName: weatherData[index].day?.condition?.text,
                          date: fulldateFormate(weatherData[index].date),
                          onTap: () => setState(() {
                            selectedIndex = index;
                          }),
                          chanceOfRain: weatherData[index]
                              .day
                              ?.dailyChanceOfRain
                              ?.toInt(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16.setWidth(),
              right: 16.setWidth(),
              top: 25.setHeight(),
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.secondaryColor, AppColors.tertiaryColor],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      assetImage(
                        "${AppAssets.baseIMG}/${(weatherData[selectedIndex].day!.condition?.text ?? "overcast").replaceAll(' ', '').toLowerCase()}.png",
                        height: 120.setHeight(),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: label(
                          (weatherData[selectedIndex].day?.maxtempC?.toInt() ??
                                  0)
                              .toString(),
                          style: AppTextStyle.normalText(
                            fontSize: 80,
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      label(
                        'o',
                        style: AppTextStyle.normalText(
                          fontSize: 40,
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      sizeBoxWidth(20),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.setWidth()),
                    child: label(
                      weatherData[selectedIndex].day?.condition?.text ?? "",
                      style: AppTextStyle.normalText(
                        color: AppColors.white70,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 40.setWidth(), vertical: 20.setHeight()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        weatherItem(
                          value: weatherData[selectedIndex]
                              .day
                              ?.maxwindKph
                              ?.toInt(),
                          unit: 'km/h',
                          imgUrl: AppAssets.windspeed,
                        ),
                        weatherItem(
                          value: weatherData[selectedIndex]
                              .day
                              ?.avghumidity
                              ?.toInt(),
                          unit: '%',
                          imgUrl: AppAssets.humidity,
                        ),
                        weatherItem(
                          value: weatherData[selectedIndex]
                              .day
                              ?.dailyChanceOfRain
                              ?.toInt(),
                          unit: '%',
                          imgUrl: AppAssets.cloud,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
