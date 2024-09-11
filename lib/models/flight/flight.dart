class Flight{
  Flight({
    this.goingId,
    this.returnId,
    this.goingCompanyId,
    this.returnCompanyId,
    this.goingCompanyName,
    this.returnCompanyName,
    this.startAirport,
    this.endAirport,
    this.className,
    this.goingDate,
    this.goingTime,
    this.returnDate,
    this.returnTime,
    this.price});

  int? goingId;
  int? returnId;
  int? goingCompanyId;
  int? returnCompanyId;
  String? goingCompanyName;
  String? returnCompanyName;
  String? startAirport;
  String? endAirport;
  String? className;
  String? goingDate;
  String? goingTime;
  String? returnDate;
  String? returnTime;
  double? price;

  factory Flight.fromJson(Map<String,dynamic> data){
    return Flight(
      price: data["price"],
      className: data["class"],
      endAirport: data["end_airport"],
      goingCompanyId: data["going_company_id"] ?? data["company_id"],
      goingCompanyName: data["going_company_name"] ?? data["company_name"],
      goingDate: data["going_date"] ?? data["date"],
      goingId: data["going_id"] ?? data["id"],
      goingTime: data["going_time"] ?? data["time"],
      returnCompanyId: data["return_company_id"],
      returnCompanyName: data["return_company_name"],
      returnDate: data["return_date"],
      returnId: data["return_id"],
      returnTime: data["return_time"],
      startAirport: data["start_airport"]
    );
  }

}