
class CommonMethods: NSObject
{
    //MARK: - Time Zone Conversion

// (LOCAL TO UTC) convert date to UTC timezone Date String with "yyyy-MM-dd hh:mm:ss a" formatter
class func convertDateToUTCDateString(date: Date) -> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.timeZone = timeZone
    let strTime: String = dateFormatter.string(from: date)
    return strTime
}

// (LOCAL TO UTC) convert date string to UTC timezone Date String with "yyyy-MM-dd hh:mm:ss a" formatter
class func convertDateStringToUTCDateString(strDate: String) -> String{
    
    let date: Date = getConvertTimeStringToDate(strDate: strDate, strFormate: "yyyy-MM-dd HH:mm:ss")
    let strTime: String = CommonMethods.convertDateToUTCDateString(date: date)
    return strTime
}

// (UTC TO LOCAL) Date to string
class func convertUTCDateToLocalDateString(date: Date) -> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let timeZone = TimeZone.current
    dateFormatter.timeZone = timeZone
    let strTime: String = dateFormatter.string(from: date)
    return strTime
}

// (UTC TO LOCAL) String to string
class func convertUTCStringToLocalDateString(strDate: String) -> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.timeZone = timeZone
    let date = dateFormatter.date(from: strDate)
    
    let strTime: String = CommonMethods.convertUTCDateToLocalDateString(date: date!)
    return strTime
}

// Managing UTC To Time zone
class func addOrSubtractTimeInUTCDate(minutes:Int,date:Date) -> String{
    let aDate = (Calendar.current).date(byAdding: .minute, value: minutes, to: date)
    let aDateFormatter = DateFormatter()
    aDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let aStrFinalDateTime = aDateFormatter.string(from: aDate!)
    return aStrFinalDateTime
}

// Managing UTC To Time zone For Get Panding matches
class func addOrSubtractTimeInUTCDateForGetPandingMatches(minutes:Int,strDate:String) -> String{
    
    let date = CommonMethods.getConvertTimeStringToDate(strDate: strDate, strFormate: "yyyy-MM-dd HH:mm:ss")
    
    let aDate = (Calendar.current).date(byAdding: .minute, value: (minutes * -1), to: date)
    let aDateFormatter = DateFormatter()
    aDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let aStrFinalDateTime = aDateFormatter.string(from: aDate!)
    return aStrFinalDateTime
}
}
