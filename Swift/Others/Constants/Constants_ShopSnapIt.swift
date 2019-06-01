//
//  Constants.swift
//  ShopSnapIt
//
//  Created by Moveo Apps on 12/06/17.
//  Copyright © 2017 Moveo Apps. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

//Base url
struct BaseurlString {
    static let BASE_URL                 = "http://shopsnapit.dev-applications.net/api"  // Development
    //static let BASE_URL               = "http://app.dev-applications.net/api"  // Production (Live)
}

struct EndPointPath {
    static let LOGIN                = "/auth/login"
    static let SIGNUP               = "/auth/signup"
    static let REGISTERFORPUSH      = "/user/devices"
    static let LOGOUTUSER           = "/user/logout"
    static let VERIFICATION         = "/auth/verification"
    static let RESENDVERIFICATION   = "/auth/resendverification"
    static let UPLOADPHOTO          = "/user/uploadphoto"
    static let SETUSERTYPE          = "/user/setusertype"
    static let RECOVERYPASS         = "/auth/recovery"
    static let RESETPASSWORD        = "/auth/reset"
    static let GETFEEDS             = "/feed/getfeeds"
    static let GETFEEDDETAIL        = "/feed/getfeeddetails"
    static let SOCIALSIGNUP         = "/auth/socialsignup"
    static let GETCOUNTRIES         = "/getcountries"
    static let GETSTATES            = "/country/getstates"
    static let ADDEDITPRODUCTMEDIA  = "/product/addeditproductmedia"
    static let REMOVEPRODUCTMEDIA   = "/product/removeproductmedia"
    static let ADDPRODUCT           = "/product/addproduct"
    static let EDITPRODUCT          = "/product/editproduct"
    static let SELLERBUSINESSINFO   = "/user/setsellerbusinessinfo"
    static let SELLERBANKINFO       = "/user/setsellerbankinfo"
    static let LIKECOMENTFEED       = "/feed/setinteraction"
    static let GETUSERSUGGESTION    = "/user/getusersuggestions"
    static let SETFOLLOWEUSER       = "/user/setfollowuser"
    static let PRODUCTUNLIKE        = "/feed/productunlike"
    static let GETUSERPROFILE       = "/user/getuserprofile"
    static let GETUSERITEMS         = "/user/getuseritems"
    static let GETFOLLOWERLIST      = "/user/getfollowers"
    static let GETFOLLOWINGLIST     = "/user/getfollowings"
    static let SEARCHPRODUCTS       = "/user/searchproducts"
    static let EDITPROFILE          = "/user/editprofile"
    static let GETBIDPRODUCT        = "/product/getproductbids"
    static let ADDBIDPRODUCT        = "/product/setproductbid"
    static let ACCEPTBID            = "/product/acceptbid"
    static let GETPRODUCTSBIDS      = "/product/getproductbids"
    static let GETNOTIFICATIONS     = "/user/getnotifications"
    static let CHANGEPASSWORD       = "/user/changepassword"
    static let GETSELLERINFO        = "/user/getsellerinfo"
    static let GETUSERCONVERSATION  = "/user/getuserconversation"
    static let SENDMESSAGE          = "/user/sendmessage"
    static let GETALLCONVERSATIONS  = "/user/getalluserconversations"
    static let REPORTPOST           = "/user/reportpost"
    static let GETBILLINGSHIPPINGADDRESS    = "/user/getdeliverybillingaddress"
    static let SETDELIVERYADDRESS   = "/user/setdeliveryaddress"
    static let SETBILLINGADDRESS    = "/user/setbillingaddress"
    static let SHAREPRODUCTMESSAGE  = "/user/sharedproductmessage"
    static let GETCLIENTTOKEN       = "/user/generateclienttoken"
    static let SETBUYERCARDS        = "/user/setbuyercards"
    static let REPORTPORBLEM        = "/user/reportproblem"
    static let REMOVEADDRESS        = "/user/removeaddress"
    static let REMOVEBUYERCARD      = "/user/removebuyercard"
    static let PURCHASEPRODUCT      = "/user/purchaseproduct"
    static let PURCHASESUBSCRIPTION = "/user/purchasesubscription"
    static let REMOVEPOST           = "/product/removeproduct"
    static let GETSELLERORDER       = "/user/getsellerorders"
    static let GETBUYERORDERHISTORY = "/user/getbuyerordershistory"
    static let GETMYREWARDPOINTS    = "/user/getrewardpoints"
    static let CHANGEORDERSTATUS    = "/user/changeorderstatus"
    static let BUYFOLLOWERSPLAN     = "/user/getfollowerplans"
    static let PURCHASEFOLLOWERS    = "/user/purchasefollowers"
    static let GETORDERSUBSCRIPTIONDETAILS = "/user/getordersubscrptionsdetails"
    static let CANCELSUBSCRIPTION   = "/user/cancelsubscription"
    static let VARIFYACCOUNT        = "/user/verifyaccount"
    static let GETEXPLOREUSERS      = "/user/getexploreusers"
    static let UPDATEACCOUNTSTATUS  = "/user/accountprivate"
    static let ACCEPTFOLLOWREQUEST  = "/user/acceptrequest"
    static let REJECTFIOLLOWREQUEST = "user/rejectrequest"
    static let GETPRODUCTLIKES      = "/feed/getproductlikes"
    static let GETBLASTPLANS        = "/user/getblastplans"
    static let PURCHASEBLASTS       = "/user/purchaseblasts"
    static let UPLOADAUDIO          = "/user/uploadaudio"
    static let REMOVEMEDIA          = "/user/removevideoaudio"
}

//Twitter Constant Key
struct TwitterKey{
    static let CONSUMER_KEY     = "pfA0ixLFNLRor31W9V9OUfcew"
    static let CONSUMER_SECRET  = "3jBByc1uCbRqP41p7HpfWwS0Gfx6Bnbic65JfsGbjIojo3RlhB"
}

//Instagram Constant Key
struct InstagramKey {
    
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
    static let INSTAGRAM_CLIENT_ID  = "3b75f6517fb34df5a8bd7d3c21586a18"
    static let INSTAGRAM_CLIENTSERCRET = "41f3bedd03974a88a787b342a9bfaa34"
    static let INSTAGRAM_REDIRECT_URI = "https://www.google.co.in/"
    static let INSTAGRAM_ACCESS_TOKEN =  "access_token"
    static let INSTAGRAM_SCOPE = "likes+comments+relationships"
    
}

//Google Constant Key
struct GoogleKey {
    
    static let PlaceApiKey = "AIzaSyA3mowFqnlHlkVyFzqs0Gf7OvXs9C3V43o"
}

//Braintree Keys
struct BraintreeKey {
    
    static let urlScheme = "com.shopsnapit.payments"
}


//Color
let CLRTHEME  = UIColor.init(colorLiteralRed: 212.0/255.0, green: 39.0/255.0, blue: 40.0/255.0, alpha: 1.0)
struct Colors {
    
    static let DarkGray404040   = UIColor.init(colorLiteralRed: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
    static let DarkGray494949   = UIColor(colorLiteralRed: 73/255.0, green: 73/255.0, blue: 73/255.0, alpha: 1.0)
    static let LightGrayC0C0C5  = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1)
    static let THEMEYELLOW      = UIColor(red:253.0/255.0, green:191.0/255.0, blue:34.0/255.0, alpha:1)
    static let THEMERED         = UIColor(red:217.0/255.0, green:45.0/255.0, blue:45.0/255.0, alpha:1)
    static let THEMEORANGE      = UIColor(red:255.0/255.0, green:110.0/255.0, blue:0.0/255.0, alpha:1)
    static let Gray127          = UIColor(red:127.0/255.0, green:127.0/255.0, blue:127.0/255.0, alpha:1)
    static let Gray98           = UIColor(red:98.0/255.0, green:98.0/255.0, blue:98.0/255.0, alpha:1)
    static let Gray72          = UIColor(red:72.0/255.0, green:72.0/255.0, blue:72.0/255.0, alpha:1)
}

//Font
struct FONT{
    static let Lato17 = UIFont(name: "Lato", size: 17)
    static let Lato_bold = "Lato-Bold"
    static let Lato_regular = "Lato"
}

//Result Keys
struct RESULT {
    static let MESSAGE              = "message"
    static let SUCCESS              = "success"
    static let DATA                 = "data"
    static let META                 = "meta"
    static let CODE                 = "code"
}

//Storyboard ids
struct StoryboardId {
    static let AUTHENTICATION       = "Authentication"
    static let MAIN                 = "Main"
    static let COMMON               = "Common"
    static let PROFILE              = "Profile"
    static let CHECKOUT             = "Checkout"
    static let ORDER                = "Order"
}

//ViewController ids
struct VCId {
    static let NAV_AUTH_VC          = "NavAuthenticationVC"
    static let SIGNIN               = "SignInVC"
    static let VERIFICATIONVC       = "VerificaitionVC"
    static let USERPROFILEVC        = "UserProfileVC"
    static let USERTYPEVC           = "UserTypeVC"
    static let NAV_HOME_VC          = "NavHomeVC"
    static let HOMEVC               = "HomeVC"
    static let NAV_EXPLORER_VC      = "NavExplorerVC"
    static let GENERALWEBVIEW       = "GeneralWebPageLoaderVC"
    static let RESETPASSEORDVC      = "ResetPasswordVC"
    static let CREATEPOSTPOPUPVC    = "CreatePostPopUpVC"
    static let NAVCREATEPOSTPOPUP   = "CreatePostPopUpNVC"
    static let POSTPRODUCTVC        = "PostProductVC"
    static let SELLERINFORMATIONVC  = "SellerInformationVC"
    static let NAV_SELLER_INFO      = "navSellerInformationVC"
    static let MAP_ADDRESSVC        = "MapAddressVC"
    static let GLOBALTABLEVC        = "GlobalTableVC"
    static let PROFILEVC            = "ProfileVC"
    static let MENUHOSTVC           = "MenuHostVC"
    static let SETTINGSVC           = "SettingVC"
    static let MESSAGEVC            = "MessageVC"
    static let NOTIFICAITONVC       = "NotificationsVC"
    static let NAVNOTIFICAITONVC    = "NavNotificationsVC"
    static let DELIVERYVC           = "DeliveryVC"
    static let REPORTPOSTVC         = "ReportPostVC"
    static let CONVERSATIONVC       = "ConversationVC"
    static let SHAREVC              = "ShareFeedVC"
    static let PAYMENTOPTVC         = "PaymentOptionsVC"
    static let CARDDETAILVC         = "CardDetailsVC"
    static let FINESHVC             = "FineshVC"
    static let ORDERHISTORYVC       = "OrderHistoryVC"
    static let YOURORDERVC          = "YourOrderVC"
    static let NAVORDERHISTORYVC    = "NavOrderHistoryVC"
    static let NAVYOURORDERVC       = "NavYourOrderVC"
    static let NAV_BUYFOLLOWERS_VC  = "NavBuyFollowersVC"
    static let TERMSANDCONDITIONSVC = "TermsAndConditionsVC"
    static let NAVSUPPORTVC         = "NavSupportVC"
    static let SEARCHVC             = "SearchVC"
    static let USERSUGGESTIONVC     = "UserSuggestionVC"
    static let BLASTPRODUCTVC       = "BlastProductVC"
    static let FULLSCREENIMGVC      = "FullScreenImageVC"
    
}

//UserDefault Keys
struct UDKeys {
    static let ISUSERLODEDIN        = "isUserLodedIn"
    static let DEVICETOKEN          = "deviceToken"
    static let USERDATA             = "userData"
    static let USERTOKEN            = "UserToken"
    static let SELLERINFO           = "SellerInfo"
}

//Segue identifiers
struct Segue {
    static let TOSETTINGSVC             = "pushToSettingsVC"
    static let SIGNUPTOVERIFICATION     = "signUpToVerification"
    static let TOUSERPROFILEVC          = "toUserProfileVC"
    static let TOUSERTYPEVC             = "toUserTypeVC"
    static let TORESTEPASSWORD          = "toResetPasswordVC"
    static let TOINSTAGRAMSIGNINVC      = "toInstagramSigninVC"
    static let SIGNINTOPROFILEVC        = "signInToProfileVC"
    static let TOSELECTCOUNTRYVC        = "toSelectCountryVC"
    static let TOSELECTSTATEVC          = "toSelectStateVC"
    static let TOSELLERINFOVC           = "toSellerInformationVC"
    static let TOFULLSCREENVC           = "presentFullScreenVC"
    static let TOFULLSCREENVCFORMPROFILE           = "FromProfileToFullScreenVC"
    static let UNWINDTOHOMEVC           = "unwindToHomeVC"
    static let UNWINDTOHOMEWITHREFRESHVC           = "unwindToHomeVCWithRefresh"
    static let UNWINDTOHOMEPOSTVC       = "unwindToHomePostVC"
    static let TOFEEDDETAILSVC          = "toFeedDetailsVC"
    static let TOFEEDDETAILSVCFROMPROFILE          = "ProfiletoFeedDetailsVC"
    static let TOUSERSUGGESTIONVC       = "toUserSuggestionVC"    
    static let UNWINDTOFEEDDETAILSVC    = "unwindToFeedDetailsVC"
    static let TOPROFILEVC              = "toProfileVC"
    static let TOFOLLOWERSLIST          = "toFollowersList"
    static let TOFOLLOWWINGLIST         = "toFollOWINGList"
    static let TOITEMS                  = "toItems"
    static let TOFULLSCREENVCFORMPITEMS = "FromITEMSToFullScreenVC"
    static let FROMFOLLOWERSTOPROFILE   = "fromFollowersToUserProfile"
    static let FROMFOLLOWINGTOPROFILE   = "fromFollowingToUserProfile"
    static let PRESENTBIDNOWPOPUP       = "presentBidNowPopUp"
    static let TOEDITPROFILEVC          = "toEditProfileVC"
    static let TOBIDFORSELLERVC         = "toBidForSellerVC"
    static let TOMESSAGEVC              = "showMessageVC"
    static let SHOWCHATDETAILS       = "showChatDetails"
    static let TOADDRESSVC              = "toAddressVC"
    static let UNWINDTODELIVERYVC       = "unwindToDeliveryVC"
    static let TOADDRESSLISTVC          = "toAddressListVC"
    static let UNWINDTOADDRESSLISTVC    = "unwindToAddressListVC"
    static let TOTERMS                  = "pushToTerms"
}

//NIB Id
struct NibId {
    static let HOMEPRODUCTCELL          = "HomeProductCell"
    static let HOMESERVICECELL          = "HomeServiceCell"
    static let HOMECLNCELL              = "HomeClnCell"
    
}

//Cell Id
struct CellId {
    static let SETTINGS                 = "SettingsCell"
    static let PRODUCT                  = "ProductCell"
    static let SERVICE                  = "ServiceCell"
    static let PRODUCTHIDDEN            = "ProductCellHidden"
    static let SERVICEHIDDEN            = "ServiceCellHidden"
    static let COUNTRY                  = "CountryTblCell"
    static let STATE                    = "StateTblCell"
    static let ProductPhotoVideoColCell = "ProductPhotoVideoColCell"
    static let ProductDropValueTblCell  = "ProductDropValueTblCell"
    static let UserSuggestionTblCell    = "UserSuggestionTblCell"
    static let CommentCell              = "CommentCell"
    static let USERSIMPLECELL           = "UserSimpleCell"
    static let HOMEIMGCELL              = "homeImgCell"
    static let BidForSellerCell         = "BidForSellerCell"
    static let AddressListCell          = "AddressListCell"
    static let HomeCell                 = "HomeCell"
}
//PushNotificationType
struct PushNotificationType{
    static let LIKE                     = "like"
    static let COMMENT                  = "comment"
    static let ACCEPT_BID               = "acceptbid"
    static let BID                      = "bid"
    static let FOLLOW                   = "follow"
    static let MESSAGE                  = "message"
    static let SHARE                    = "share"
    static let PRODUCTSHARE             = "productshare"
    static let FOLLOWREQUEST            = "followrequest"
    static let OUTBID                   = "outbid"
}

//Strings
let EMPTYSTRING         = ""

//UserDefault
let USERDEFAULTS        = UserDefaults.standard

//AppDelegate
let APPDELEGATE         = UIApplication.shared.delegate as! AppDelegate

//Application Name 
let APPLICATIONNAME         = "ShopSnapIt"

//In App Purchase identifiers
enum IAPFOLLOWERS :String{
    case FOLLOWERS100       = "com.shopsnapit.purchase.100Followers"
    case FOLLOWERS500       = "com.shopsnapit.purchase.500Followers"
    case FOLLOWERS1000      = "com.shopsnapit.purchase.1000Followers"
}

enum SubscriptionType :String{//month/year/onetime
    case ONETIME      = "onetime"
    case MONTHLY      = "month"
    case YEARLY       = "year"
}

//Alert Validation Messages
struct AlertMessages {
    static let PLEASE_ENTER                 = "Please enter"
    static let EMPTY_CLIENTCODE             = "Please enter client code."
    static let NODATAFOUND                  = "No data found."
    static let NOINTERNET                   = "Please check the internet connectivity."
    static let EMPTY_NAME                   = "Please enter name."
    static let EMPTY_FIRST_NAME             = "Please enter first name."
    static let EMPTY_LAST_NAME              = "Please enter last name."
    static let EMPTY_USERNAME               = "Please enter user name."
    static let EMPTY_EMAIL                  = "Please enter email address."
    static let EMPTY_MOBILE_EMAIL           = "Please enter mobile number or email address."
    static let EMPTY_COUNTRY                = "Please select country."
    static let VALID_MOBILE_EMAIL           = "Please enter valid mobile number or email address."
    static let EMPTY_PASSWORD               = "Please enter password."
    static let EMPTY_NEW_PASSWORD           = "Please enter new password."
    static let EMPTY_OLD_PASSWORD           = "Please enter old password."
    static let EMPTY_CURR_PASSWORD          = "Please enter current password."
    static let EMPTY_REENTER_NEW_PASSWORD   = "Please re-enter new password."
    static let EMPTY_CONF_PASSWORD          = "Please enter confirm password."
    static let NOT_MATCH_PASS               = "Password and Confirm Password does not match."
    static let NOT_MATCH_NEW_PASS           = "New Password and re-enter new password does not match."
    static let EMPTY_VERIFICATION           = "Please enter verification code."
    static let NOT_MATCH_VERIFICATION       = "Verification code do not match."
    static let EMPTY_PHONE                  = "Please enter phone number."
    static let EMPTY_MSG                    = "Please enter message."
    static let EMPTY_DATETIME               = "Please enter date and time."
    static let EMPTY_SUBJECT                = "Please enter subject."
    static let INVALID_EMAIL                = "Please enter valid email address."
    static let INVALID_CONTACT              = "Please enter valid contact number."
    static let ENTER_PHOTOVIDEO             = "Please select product photo/video."
    static let ENTER_ONE_PHOTOVIDEO         = "Please upload at least one photo/video."
    static let ENTER_TITLE                  = "Please enter product title."
    static let ENTER_SERVICE_TITLE          = "Please enter service title."
    static let ENTER_DISCRIPTION            = "Please enter product description."
    static let ENTER_SERVICE_DISCRIPTION    = "Please enter service description."
    static let ENTER_PRICE                  = "Please enter product price."
    static let ENTER_MINBID_PRICE           = "Please enter minimum bid price."
    static let ENTER_ONETIME_PRICE          = "Please enter one time subscription price."
    static let ENTER_MONTHLY_PRICE          = "Please enter monthly subscription price."
    static let ENTER_SUBSCRIPTION_PRICE     = "Please enter at least one subscription price."
    static let ENTER_AUCTION_DATE           = "Please enter product auction date and time."
    static let ENTER_SHIPPING_PRICE         = "Please enter national shipping price."
    static let ENTER_BUSINESSNAME           = "Please enter business name."
    static let EMPTY_CONTACT                = "Please enter contact number."
    static let EMPTY_BUSINESSEMAIL          = "Please enter business email."
    static let EMPTY_BIRTHDATE              = "Please enter date of birth."
    static let EMPTY_ADDRESS                = "Please enter address."
    static let EMPTY_CITY                   = "Please enter city."
    static let EMPTY_STATE                  = "Please enter state."
    static let EMPTY_ZIP                    = "Please enter zip code."
    static let EMPTY_BANKNAME               = "Please enter bank name."
    static let EMPTY_ROUTINGNO              = "Please enter routing number."
    static let EMPTY_ACCNUMBER              = "Please enter account number."
    static let EMPTY_ACCNAME                = "Please enter account name."
    static let EMPTY_COMMENT                = "Please enter comment."
    static let EMPTY_SELLERINFO             = "Please enter all business details."
    static let ALERT_LOGOUT_MSG             = "Are you sure you want to Logout?"
    static let INVALID_BID_PRICE            = "Please enter valid bid amount."
    static let BID_PRICE_GRETER             = "Your bid amount should be greater than recent bid amount."
    static let ENTER_BID_AMOUNT             = "Please enter bid amount."
    static let SELECTONEUSER                = "Please select at least one user."
    static let ENTER_SHIPPINGADDRS          = "Please enter shipping address."
    static let ENTER_BILLINGADDRS           = "Please enter billing address."
    static let ENTER_NAME_CARD              = "Please enter name on card."
    static let ENTER_CARD_NUM               = "Please enter card number."
    static let ENTER_EXP_MNTH               = "Please enter expiry month."
    static let ENTER_EXP_YEAR               = "Please enter expiry year."
    static let VALID_CARD_EXP_DATE          = "Card expiration date should be greater than current date."
    static let ENTER_CVC                    = "Please enter CVC code."
    static let ENTER_YOUR_WORKING           = "Please enter your wording."
    static let ENTER_FILTER                 = "Please enter filter along with hashtags."
    static let PRICEGRETERMINBID            = "Price should be greater than minimum bid price."
    static let ACCEPTPRIVACY                = "Please accept terms and data policy."
    static let ENTER_DROPHOUR               = "Please enter drop hour."
    static let ENTER_DROPVALUE              = "Please enter drop value."
    static let ENTER_DROPTYPE               = "Please enter drop type."
    static let ENTER_SHIPPINGPRICE          = "Please enter shipping price."
}

//Media Types
struct MediaTypes {
    static let MOVIE    = kUTTypeMovie as String
    static let IMAGE    = kUTTypeImage as String
}

//Values
struct Values {
    static let IOSDEVICE    = "IOS"
}

//User Type
struct UserType {
    static let TYPE_BUYER   = "buyer"
    static let TYPE_SELLER  = "seller"
}

//Social Type
struct SocialType {
    static let FACEBOOK     = "facebook"
    static let TWITTER      = "twitter"
    static let INSTAGRAM    = "instagram"
}

//Int Values
struct IntValues {
    static let ZERO             = 0
    static let ONE              = 1
    static let TWO              = 2
    static let THREE            = 3
    static let FOUR             = 4
    static let TWO_HUNDRED      = 200
}

//Int Help Cell Tag
struct HELPCELL {
    static let IMAGE            = 1
    static let TITLE            = 2
    static let DESCRIPTIOn      = 3
}


//Image name
struct IMG {
    static let LOGO     = "Logo"
}

struct Keys {
    static let imageName        = "imageName"
    static let title            = "title"
    static let code             = "code"
    static let name             = "name"
    static let firstName        = "firstname"
    static let lastName         = "lastname"
    static let userName         = "username"
    static let uName            = "uname"
    static let password         = "password"
    static let oldpassword      = "old_password"
    static let confPassword     = "confirm_password"
    static let passwordConf     = "password_confirmation"
    static let deviceType       = "device_type"
    static let deviceToken      = "device_token"
    static let email            = "email"
    static let phone            = "phone"
    static let countryCode      = "country_code"
    static let countryId        = "country_id"
    static let subject          = "subject"
    static let datetime         = "datetime"
    static let verificationCode = "verification_code"
    static let userId           = "user_id"
    static let avatar           = "avatar"
    static let avatarThumb      = "avatar_thumb"
    static let avatarAudio      = "avatar_audio"
    static let type             = "type"
    static let token            = "token"
    static let socialId         = "socialid"
    static let gender           = "gender"
    static let socialType       = "socialtype"
    static let description      = "description"
    static let price            = "price"
    static let sellType         = "sell_type"
    static let auctionDate      = "auction_date"
    static let defaultMedia     = "default_media"
    static let defaultMediaType = "default_media_type" //video/image
    static let mediaTitle       = "media_title"
    static let mediaCount       = "media_count"
    static let mediaType        = "media_type"
    static let mediaFile        = "media_file"
    static let mediaThumb       = "media_thumb"
    static let cropedImage      = "media_file_croped"
    static let sortOrder        = "sort_order"
    static let dropCount        = "drop_count"
    static let dropHours        = "drop_hours"
    static let dropValues       = "drop_value"
    static let dropId           = "drop_id"
    static let valueType        = "value_type" //percentage/amount
    static let isPublic         = "is_public" //0->private, 1->public
    static let medias           = "medias"
    static let comment          = "comment"
    static let businessName     = "business_name"
    static let businessContact  = "business_contact"
    static let businessEmail    = "business_email"
    static let businessAddress  = "business_address" //(street) -> required
    static let businessCity     = "business_city"   //required
    static let businessCountry  = "business_country"
    static let businessState    = "business_state"  //required
    static let businessZipcode  = "business_zipcode"//required
    static let dob              = "dob"             //(Y-m-d) -> required
    static let bankName         = "bank_name"
    static let rountingNumber   = "rounting_number" //required
    static let accountNumber    = "account_number" // required
    static let accountName      = "account_name"
    static let productId        = "product_id"
    static let isFollow         = "is_follow"
    static let keyword          = "keyword"
    static let seeAll           = "see_all"
    static let users            = "users"
    static let products         = "products"
    static let bio              = "bio"
    static let country          = "country"
    static let limit            = "limit"
    static let bidId            = "bid_id"
    static let reason           = "reason"
    static let contact          = "contact"
    static let address          = "address"
    static let city             = "city"
    static let state            = "state"
    static let zipCode          = "zipcode"
    static let addressId        = "address_id"
    static let nonce            = "nonce"
    static let method           = "method"
    static let usertagIds       = "usertag_ids"
    static let addressType      = "Type"
    static let cardId           = "card_id"
    static let purchaseType     = "purchase_type"
    static let buyerCardId      = "buyer_card_id"
    static let offset           = "offset"
    static let deliveryFee      = "delivery_fee"
    static let deliveryFeeGlobal = "delivery_fee_global"
    static let isActive         = "is_active"
    static let transectionID    = "transaction_id"
    static let status           = "status"
    static let isSame           = "is_same"
    static let isAuto           = "is_auto"
    static let deliberyAddressId        = "delivery_address_id"
    static let billingAddressId         = "billing_address_id"
    static let subscriptionDuration     = "subscription_duration"
    static let subscriptionDurType      = "subscription_duration_type"
    static let subscriptionOneTimePrice     = "subscription_one_time"
    static let subscriptionMonthlyPrice     = "subscription_monthly_price"
    static let subscriptionYearlyPrice      = "subscription_yearly_price"
    static let receiptData                  = "receipt_data"
    static let minBidValue      = "min_bid_value"
    static let productType      = "product_type"
    static let coin             = "coin"
}

struct SettingsMenuItems {
    static let LOGOUT               = "Logout"
}

enum WebPageURL : String{
    case APPSTORE   = "https://itunes.apple.com/us/app/"
    case GOOGLE     = "https://www.google.com"
}

let arrMyProfileVideoOptions        = ["View Video","Delete Video","Photo Library","Camera"]
let arrMyProfilePickerOptions       = ["Photo Library","Camera"]
let arrMyProfileSongOptions         = ["Update Audio","Delete Audio"]
let arrOtherUserProfileVideoOptions = ["View Video"]
//let arrOtherUserProfileImageOptions   = ["View Image"]

//Date Formate
struct DATEFORMATE {
    static let USA              = "MM/dd/yy"
    static let US_DATE          = "MMM dd, yyyy"
    static let WEBSERVICEFORM   = "yyyy-MM-dd"
    static let US_DATE_DAY      = "E, MMM dd, yyyy"
}

struct DATETIMEFORMATE {
    static let DEFAULTFORWS     = "yyyy-MM-dd HH:mm"
    static let WEBSERVICEFORM   = "yyyy-MM-dd HH:mm:ss"
    static let US               = "MMM dd, yyyy HH:mm"
    static let US_12HOUR        = "MMM dd, yyyy • hh:mm a"
}

struct TIMEFORMATE {
    static let HOUR12           = "hh:mm a"
}

//Other Constant
struct OtherConstant {
    
    static let DollarValueInPoint = 20
    
    static let DescriptionPlaceholder   = "Add #hashtags. #HASHTAGS #ARE #VERY #IMPORTANT"
    static let BidderConfirmationMsg    = "Are you sure to accept bid of this user?"
    
    enum SellType:String  {
        case sell   = "sell"
        case bid    = "bid"
        case both   = "both"
    }
    
    enum AddressType:String{
        case shipping   = "shipping"
        case billing    = "billing"
    }
    
    enum PaymentMethod:String{
        case card       = "card"
        case paypal     = "paypal"
    }
    
    enum ProductType:String{
        case product    = "product"
        case service    = "service"
    }
    
    enum OrderStatus:String {
        case processing   = "Processing"
        case shipping     = "Shipping"
        case delivered    = "Delivered"
    }
    
    enum RewardPoints:String {
        case credit       = "credit"
        case debit        = "debit"
    }
        
    static let US_COUNTRY_CODE      = "+1"
    static let US_COUNTRY_NAME      = "United States"
    static let US_COUNTRY_ID        = 223
}

//Static Strings
let SPACE               = " "
let DOT                 = "."
let EXCLAMATION         = "!"
let SINGLEQUOTE         = "'"
let BLANKSPACE          = ""
let DUMMYTOKEN          = UIDevice.current.identifierForVendor!.uuidString
let IOS                 = "IOS"
let INDICATERTAG        = 987
let HELPTEXT1           = "Post a Product"
let HELPTEXT2           = "Post a Service"
let HELPTEXT3           = "Payment"
let HELPTEXT4           = "Order History"
let HELPTEXT5           = "Home Screen"

let HELPDETAILSTEXT1    = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
let HELPDETAILSTEXT2    = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
let HELPDETAILSTEXT3    = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
let HELPDETAILSTEXT4    = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
let HELPDETAILSTEXT5    = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
