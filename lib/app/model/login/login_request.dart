class LoginRequest {
    String? countryCode;
    String? phone;

    LoginRequest({
        this.countryCode,
        this.phone,
    });

    factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        countryCode: json["country_code"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "country_code": countryCode,
        "phone": phone,
    };
}
