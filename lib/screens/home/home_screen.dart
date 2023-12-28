import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/home/home_bloc.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/utils/assets.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/common_codes.dart';
import 'package:weather_app/utils/routes.dart';
import 'package:weather_app/utils/size_config.dart';
import 'package:weather_app/utils/strings.dart';
import 'package:weather_app/utils/text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherModel weatherData = WeatherModel();
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    context.read<HomeBloc>().add(FetchDataEvent("Pune"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is FetchedDataState) {
          weatherData = state.weatherData;
        }
        return scaffoldLoader(
          key: scaffoldKey,
          showLoader: isLoading,
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  ListTile(
                    leading: assetImage(AppAssets.user, height: 30.setHeight()),
                    title: label(
                      FirebaseAuth.instance.currentUser?.displayName ??
                          AppStrings.user,
                      style: AppTextStyle.normalText(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: label(
                      FirebaseAuth.instance.currentUser?.email ?? "",
                      style: AppTextStyle.normalText(
                        fontSize: 12,
                        color: AppColors.tertiaryColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  textButton(
                    onPressed: () async {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          RouteName.loginScreen, (route) => false);
                    },
                    title: AppStrings.logout,
                  )
                ],
              ),
            ),
          ),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(10.setHeight()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    height: 580.setHeight(),
                    decoration: BoxDecoration(
                      gradient: linearGradient(),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                scaffoldKey.currentState!.openDrawer();
                              },
                              icon: assetImage(
                                AppAssets.menu,
                                height: 20.setHeight(),
                              ),
                            ),
                            const Spacer(),
                            assetImage(
                              AppAssets.pin,
                              height: 20.setHeight(),
                            ),
                            sizeBoxHeight(2),
                            label(
                              weatherData.location?.name ?? "Pune",
                              style: AppTextStyle.normalText(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                searchController.clear();
                                showModalBottomSheet(
                                  context: context,
                                  constraints: BoxConstraints(
                                    maxHeight: 400.setHeight(),
                                  ),
                                  builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                      top: 16.setHeight(),
                                      left: 16.setHeight(),
                                      right: 16.setHeight(),
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: Column(
                                      children: [
                                        SimpleTextField(
                                          controller: searchController,
                                          hintText: AppStrings.searchHint,
                                          onCompleted: () =>
                                              Navigator.pop(context),
                                          onChanged: (value) => context
                                              .read<HomeBloc>()
                                              .add(FetchDataEvent(value == ""
                                                  ? "Pune"
                                                  : value)),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        assetImage(
                          "${AppAssets.baseIMG}/${(weatherData.current?.condition?.text ?? "overcast").replaceAll(' ', '').toLowerCase()}.png",
                          height: 150.setHeight(),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: label(
                                (weatherData.current?.tempC?.toInt() ?? 0)
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
                          ],
                        ),
                        label(
                          weatherData.current?.condition?.text ?? "",
                          style: AppTextStyle.normalText(
                            color: AppColors.white70,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          fulldateFormate(weatherData.location?.localtime
                              ?.substring(0, 10)),
                          style: AppTextStyle.normalText(
                            color: AppColors.white70,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20.setWidth()),
                          child: const Divider(
                            color: AppColors.white70,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 40.setWidth()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              weatherItem(
                                value: weatherData.current?.windKph?.toInt(),
                                unit: 'km/h',
                                imgUrl: AppAssets.windspeed,
                              ),
                              weatherItem(
                                value: weatherData.current?.humidity?.toInt(),
                                unit: '%',
                                imgUrl: AppAssets.humidity,
                              ),
                              weatherItem(
                                value: weatherData.current?.cloud?.toInt(),
                                unit: '%',
                                imgUrl: AppAssets.cloud,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.today,
                            style: AppTextStyle.normalText(
                              fontWeight: FontWeight.bold,
                              color: AppColors.tertiaryColor,
                              fontSize: 18,
                            ),
                          ),
                          textButton(
                            onPressed: () => Navigator.of(context).pushNamed(
                              RouteName.detailScreen,
                              arguments: weatherData.forecast!.forecastday,
                            ),
                            title: AppStrings.forecasts,
                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      ),
                      sizeBoxHeight(8),
                      SizedBox(
                        height: 110.setHeight(),
                        child: ListView.builder(
                          itemCount: weatherData
                                  .forecast?.forecastday?.first.hour?.length ??
                              0,
                          padding: const EdgeInsets.all(2),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            List<Hour> hourlyWeatherForecast =
                                weatherData.forecast?.forecastday?.first.hour ??
                                    [];

                            String currentTime =
                                DateFormat('HH:mm:ss').format(DateTime.now());
                            String currentHour = currentTime.substring(0, 2);

                            String forecastTime = hourlyWeatherForecast[index]
                                .time!
                                .substring(11, 16);
                            String forecastHour = hourlyWeatherForecast[index]
                                .time!
                                .substring(11, 13);

                            String forecastWeatherName =
                                hourlyWeatherForecast[index].condition!.text!;
                            String forecastWeatherIcon =
                                "${forecastWeatherName.replaceAll(' ', '').toLowerCase()}.png";

                            String forecastTemperature =
                                hourlyWeatherForecast[index]
                                    .tempC!
                                    .round()
                                    .toString();
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.setHeight()),
                              margin: EdgeInsets.only(right: 16.setWidth()),
                              width: 65,
                              decoration: BoxDecoration(
                                color: currentHour == forecastHour
                                    ? Colors.white
                                    : AppColors.primaryColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 1),
                                    blurRadius: 5,
                                    color:
                                        AppColors.primaryColor.withOpacity(.2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    forecastTime,
                                    style: AppTextStyle.normalText(
                                      fontSize: 17,
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  assetImage(
                                    "${AppAssets.baseIMG}/$forecastWeatherIcon",
                                    height: 20.setHeight(),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        forecastTemperature,
                                        style: AppTextStyle.normalText(
                                          color: AppColors.grey,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '°',
                                        style: AppTextStyle.normalText(
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
