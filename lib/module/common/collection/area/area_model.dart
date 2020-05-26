import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'area_model.g.dart';

/// 区域
@JsonSerializable()
class Area extends Equatable{
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String code;
  @JsonKey(defaultValue: '')
  final String level;
  @JsonKey(defaultValue: '')
  final String parent;
  @JsonKey(defaultValue: [])
  final List<Area> children;

  Area({this.name, this.code, this.level, this.parent, this.children});

  @override
  List<Object> get props => [name, code, level, parent, children];

  factory Area.fromJson(Map<String, dynamic> json) =>
      _$AreaFromJson(json);

  Map<String, dynamic> toJson() => _$AreaToJson(this);

  Map<String, dynamic> citiesData(String levelStr){
    return getCityMap()..addAll(getAreaMap(levelStr));
  }

  Map<String, dynamic> getAreaMap(String levelStr){
    Map<String, dynamic> map = {};
    if(levelStr == '0') {
      children.forEach((Area area) {
        map.putIfAbsent(area.code, () {
          if (area.children.length == 0) {
            return {'name': area.name};
          } else {
            return area.getAreaMap(levelStr);
          }
        });
      });
    }else if(levelStr == '1'){
      Map<String, dynamic> tempMap = {};
      children.forEach((Area area) {
        tempMap.putIfAbsent(area.code, () {
          return {'name': area.name};
        });
      });
      map.putIfAbsent(code, (){
        return tempMap;
      });
    }
    return map;
  }

  Map<String, dynamic> getCityMap(){
    Map<String, dynamic> cityMap = {};
    if(level == '0'){
      children.forEach((Area area) {
        cityMap.putIfAbsent(area.code, () {
          return {'name': area.name};
        });
      });
      return {code: cityMap};
    }else if(level == '1'){
      return {parent: {code: {'name': name}}};
    }else{
      return cityMap;
    }
  }
}
