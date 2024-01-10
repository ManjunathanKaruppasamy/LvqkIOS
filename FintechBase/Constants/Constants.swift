//
//  Constants.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 27/02/23.
//

import Foundation
import UIKit

let CHECKROOTEDDEVICE: Bool = true // Debug detection -> Enable during archieve(ipa)
let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width
var rupeeSymbol = "\u{20B9}"
var countryISO = "IN"
var APPVERSION = "1.0"
var PLATFORM = "ios"
var TENANT = "lqfleet"
var CORPORATE = ""
var ENTITYID = ""
var DEVICEID = ""
var ACCESSTOKEN = ""
var REFRESHTOKEN = ""
var DOB = ""
var EMAIL = ""
var entityType = "16" // For vehicle
var TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoibHFmbGVldCIsImlhdCI6MTY3OTYzMDU3M30.fMVGKsKlk88Lfjwa3ozJ400zCHct3VmiqiTTXtmRLws"
var IFSC = "YESB0CMSNOC"
var cardDetailsArray: GetCardResultArray? // For invoke sdk
let PDFFITMENTCERTIFICATE = "Fitment Certificate"
let PDFRECEIPTFILENAME = "TransactionReceipt"
let PARENTFOLDERNAME = "LivQuik"
var isMinKYC = true
var isvkycStatusCompleted = false
var isSensitiveData = true
var pendingVKYCLimit = 10000.00
var completedVKYCLimit = 200000.00
var walletBalance = 0.00
var minimumBalance = 200.00

var clientPrivateKeyString: String = ""
var clientPublicKeyString: String = ""
var serverPublickey: String = ""
var sharedSecret: String = ""

var digiLockBaseURL: String {
    guard let baseURL = Bundle.main.infoDictionary?["DIGI_LOCKER_BASE_URL"] as? String else {
        return ""
    }
    return baseURL
}

var AUTHKEY: String {
    guard let authkey = Bundle.main.infoDictionary?["AUTH_KEY"] as? String else {
        return ""
    }
    return authkey
}
var encryptionEnabled: String {
    guard let encrypEnabled = Bundle.main.infoDictionary?["ENCRYPTION_ENABLED"] as? String else {
        return ""
    }
    return encrypEnabled
}

var isCardProduction: Bool {
    guard let isProduction = Bundle.main.infoDictionary?["CARD_SDK_PRODUCTION"] as? String else {
        return false
    }
    return isProduction == "YES" ? true : false
}
var vkycCallBack: String {
    guard let vkycString = Bundle.main.infoDictionary?["VKYC_CALLBACK"] as? String else {
        return ""
    }
    return vkycString
}

var MPIN: String {
    get {
        (UserDefaults.standard.string(forKey: "getMpin") ?? "").convertBase64ToString() ?? ""
    } set {
        UserDefaults.standard.setValue(newValue.convertStringToBase64(), forKey: "getMpin")
    }
}

var userMobileNumber: String {
    get {
        (UserDefaults.standard.string(forKey: "userMobileNumber") ?? "").convertBase64ToString() ?? ""
    } set {
        UserDefaults.standard.setValue(newValue.convertStringToBase64(), forKey: "userMobileNumber")
    }
}

var biometricEnabled: Bool {
    get {
        UserDefaults.standard.bool(forKey: "enableBiometric")
    } set {
        UserDefaults.standard.setValue(newValue, forKey: "enableBiometric")
    }
}

var userName: String {
    get {
        (UserDefaults.standard.string(forKey: "userName") ?? "").convertBase64ToString() ?? ""
    } set {
        UserDefaults.standard.setValue(newValue.convertStringToBase64(), forKey: "userName")
    }
}

/*API CALLS and other constants*/

let PAIR = "customer/pairPublicKey"
let GENERATEBITURL = "customer/fetchBitUrl"
let ERROR = "Something went wrong. please try again"
let EMPTY = ""

// MARK: Static String
struct AppLoacalize {
    static let textString = AppLoacalize()
    
    let signin = "Sign in"
    let qww = "QW"
    let tag = "Tag"
    let walkThroughSubDescription = "Manage multiple vehicles hassle-free with QuikWallet."
    let walkThroughMainDescription = "Use FasTag Wallet balance for tolls, food, fuel, and online/offline payments with Rupay-linked card."
    let permission = "Permission"
    let allowPermission = "Allow Permission"
    let skipNow = "Skip now"
    let cancel = "Cancel"
    let selectSource = "Select Source"
    let photoLibrary = "Photo Library"
    let device = "Device"
    let camera = "Camera"
    let storage = "Storage"
    let sms = "SMS"
    let location = "Location (Optional)"
    let deviceDesc = "Set up your phone as a trusted device."
    let cameraDesc = "Grant access to click selfie for confirmation"
    let storageDesc = "Grant access to the device storage to save and \nupload files & photos"
    let smsDesc = "Authorise QuikWallet & its partners to access your SMS, for all communication. \nWe will never access your private information without your permission."
    let locationDesc = "Allow access to device location to make your experience unique and keep you safe from scams."
    let mobileVCTitle = "Let’s Start with your \nMobile Number"
    let mobileVCDescription = "An OTP will be sent to this number"
    let sendOTP = "Send OTP"
    let mobilePlaceholder = "0000000000"
    let otptitle = "Enter OTP to verify \nyour account"
    let forgotMpinOtptitle = "Enter OTP to confirm and \nupdate new MPIN"
    let otpDescription = "An OTP has been sent to"
    let verifyOTP = "Verify OTP"
    let incorrectOTP = "Incorrect OTP"
    let countryCode = "+91"
    let notReceiveOTP = "Didn’t receive an OTP?"
    let resend = "Resend"
    let verifyAccountText = "Your account has been \nverified.\n\nHang on....\nWe are fetching your account details."
    let createAccountText = "Your account is \ngetting created\n\nHang on....\nWe are fetching your details"
    let setMPIN = "Set MPIN"
    let setNewMpin = "Set new MPIN"
    let accountDetailsTitle = "Your Account Details"
    let name = "Name"
    let lastName = "Last name"
    let fasTagSerialNumber = "FasTag Serial Number"
    let quikwalletAccountNumber = "Quikwallet Account Number"
    let mobileNumber = "Mobile Number"
    let emailAddress = "Email Address"
    let dateOfBirth = "Date of Birth"
    let fromDate = "From Date"
    let toDate = "To Date"
    let address = "Address"
    let setMPINDescription = "Set MPIN to keep your account safe and \nsecure."
    let enterMPIN = "Enter MPIN"
    let reEnterMpin = "Re-enter MPIN"
    let incorrectMPIN = "Incorrect MPIN"
    let enterFourDigitMPIN = "Enter your 4-digit MPIN"
    let confirm = "Confirm"
    let mpinMismatch = "MPIN Mismatch"
    let mpinSuccess = "MPIN has been set \nsuccessfully!"
    let forgotMPIN = "Forgot MPIN"
    let useBiometric = "Use Biometric"
    let useMPIN = "Use MPIN"
    let enableBiometric = "Enable Biometric"
    let skipForNow = "Skip for now"
    let authenticationFailed = "Authentication failed"
    let authenticationFailedDesc = "You could not be verified; please try again."
    let biometryUnavailable = "Biometry unavailable"
    let biometryUnavailableDesc = "Please, Update biometric in your device setting"
    let welcomeBack = "Welcome back!"
    let unlockQuikWallet = "Unlock QuikWallet"
    let touchTheFingerprintSensor = "Touch the fingerprint sensor"
    let faceIDDescription = "Sign-in with Face ID \n\nLook directly at your front\ncamera to use Face ID"
    let forgotMpinDescription = "Please enter your date of birth \nto verify"
    let ddmmyyyy = "DD/MM/YYYY"
    let incorrectDob = "Incorrect date of birth"
    let uploadAndContinue = "Upload and continue"
    let proceed = "Proceed"
    let submit = "Submit"
    let forgotDescription = "Set new 4 digit MPIN for your account"
    let mpinUpdatedSuccessfully = "MPIN updated successfully!"
    let mpinUpdateddescription = "Your new MPIN has been updated successfully,"
    let backToLogin = "Back to Login"
    let setEmailTitle = "We need few more detail to serve you better"
    let title = "Title"
    let enterEmailAddress = "Enter Email address"
    let enterEmailAddressDescription = "We will send you notification here"
    let mister = "Mr."
    let miss = "Ms."
    let misters = "Mrs."
    
    // * Api Error Toast * //
    let somethingWentWrong = "Something went wrong"
    let userNotExist = "User doesn't exist"
    let credentialsMismatch = "Credentials Mismatch"
    let vehicleSuccessMessage = "Vehicle registered successfully"
    
    // * Dashboard * //
    let availableBalance = "Available Balance"
    let addMoney = "Add Money"
    let manageCard = "Manage Card"
    let viewAll = "View all"
    let goodToSeeYou = "Good to see you!"
    let home = "Home"
    let vehicle = "Vehicles"
    let transaction = "Transactions"
    let profile = "Profile"
    let proceedToPay = "Proceed to Pay"
    let accountBalance = "Account Balance"
    let enterAnyAmount = "Enter any amount"
    let balanceLowErrorDescription = "Your Tag Balance is running low, \nPlease recharge to avoid penalty."
    let paymentMethod = "Payment Method"
    let amountToBePaid = "Amount to be Paid"
    let preferredPaymentOptions = "Preferred Payment Options"
    let enterUPIID = "Enter UPI ID"
    let otherPaymentOptions = "Other Payment Options"
    let otherPaymentDescription = "( Applicable charges may apply.)"
    let upiPlaceHolder = "xxxxxxxxxxxxxxxxxx@testupi"
    let orString = "or"
    let payviaUPIApps = "Pay via UPI apps"
    let upiApps = "UPI Apps"
    let noAdditionalChargesforUPItransactions = "(3% Convenience fee for Credit Card UPI, No additional charges for UPI transactions.)"
    let enterUPITitle = "Enter any UPI ID/UPI Number"
    let enterUPIDescription = "Your UPI ID will be encrypted and is 100% safe with us"
    let enterUPIPlaceholder = "xxxxxxx@okicici"
    let myVehicles = "My Vehicles"
    let viewDetails = "View details"
    let viewDetailsTitle = "View Details"
    let active = "Active"
    let inActive = "In-active"
    let blocklisted = "Blocklisted"
    let vehicleNumber = "Vehicle Number"
    let downloadTagFitment = "Download Tag fitment certificate"
    let replaceFasTag = "Replace FasTag"
    let recentTransactions = "Recent Transactions"
    let nameOfTheOwner = "Name of the Owner"
    let fasTagRegisteredDate = "FasTag Registered Date"
    let vehicleClass = "Vehicle class"
    let rcRegNo = "RC Reg. No."
    let tagFitmentCertificate = "Tag Fitment Certificate"
    let download = "Download"
    let sendAnEmail = "Send an Email"
    let apply = "Apply"
    let reasonForReplacingtheFasTag = "Reason for replacing the FasTag"
    let replaceFasTagDescription = "When you replace FasTag tag, your existing FasTag will no longer be functional."
    let weWillCallBack = "We will call back!"
    let replaceFasTagSuccessPopUp = "Our customer support team will respond \nto your request within 2 business days."
    let myTransactions = "My Transactions"
    let fasTagCard = "FasTag Card"
    let mealCard = "Meal Card"
    let transactionHistory = "Transaction History"
    let filterBy = "Filter by"
    let dateRange = "Date Range"
    let transactionDetails = "Transaction Details"
    let downloadReciept = "Download Reciept"
    let raiseAnIssue = "Raise an Issue"
    let additionalDetailsHere = "Additional details here"
    let whatIsTheNatureOfTheIssue = "What is the nature of the issue?"
    let raiseanIssue = "Raise an Issue"
    let clearFilter = "Clear Filter"
    let issueRaisedSuccessfully = "Issue raised\nsuccessfully!"
    let trackIsue = "Track Issue"
    let filter = "Filter"
    let selectDateRange = "Select date range"
    let noTransactionAvailable = "No Transaction Available"
    let activeCaps = "ACTIVE"
    let inActiveCaps = "IN-ACTIVE"
    let blockedCaps = "BLOCKED"
    let upload = "Upload"
    let view = "View"
    let addVehicle = "Add Vehicle"
    let uploadDocuments = "Upload Documents"
    let acceptedFileFormats = "Accepted file formats: .jpg, .png (max size 2MB)."
    let documentDetails = "Document proofs & validation"
    let refundableBalance = "Refundable balance"
    let getYourAvailableWalletBalance = "Get your available \nwallet balance"
    let accountDetailsDescription = "To transfer the refundable balance, please enter the following details."
    let documentDetailsDescription = "For secure transfer of your refundable amount, please provide the following documents."
    let pleaseNote = "Please note..."
    let creditAccountDetailsNotes = "Wallet money will be credited to the entered account details within 15 business days."
    let negativeBalanceTitle = "Looks like you have outstanding balance to pay"
    let negativeBalanceNotes = "Outstanding balance remains in your wallet. Please settle to complete account closure. \n\nIf you have any further questions or need assistance, feel free to reach out to 18003092225."
    let rcInstructiontitle = "When uploading your RC please make ensure the following."
    let ownerDriverPhotograph = "As per Regulation, Owner or driver photograph is mandatory "
    let novehicleTitle = "No vehicle added yet ?"
    let novehicleDescription = "Buy QWFASTag now & experience \nhassle-free toll payments! Get it now"
    let verificationTitle = "We are processing your request"
    let verificationDescription = "Please Wait... \nThis usually takes up to a minute."
    let important = "Important:"
    let verificationNote = "Please do not press back or switch to another app while we are verifying your details"
    let requestSubmitted = "Request submitted !"
    let requestSubmittedDescription = "Your request to close your account has been successfully submitted."
    let requestInprogress = "Request is inprogress !"
    let requestInprogressDescription = "We'll update your Request status shortly. Thanks for your patience!"
    let requestFailed = "Request failed, please reapply."
    let requestFailedDescription = "VKYC verification process failed. Contact customer care for assistance."
    let kycFailed = "KYC Failed"
    // swiftlint:disable line_length
    let requestSubmittedNoteDescription = "• Wallet money will be credited to the entered account details within 15 business days.\n\n• Our customer support team will reach out to you to gather any additional information that may be needed.your account will be closed after a review.\n\n• If you have any further questions or need assistance, feel free to reach out to 18003092225. Thank you for being with us!"
    let supportNum = "18003092225"
    // swiftlint:enable line_length
    
    // * Manage Cards * //
    let myCards = "My Cards"
    
    // MARK: Profile flow
    
    let biometricSuccess = "Biometric Login enabled."
    let biometricFailure = "Biometric Login disabled."
    let logout = "Logout"
    let mpinChangeSuccess = "MPIN changed successfully !"
    
    let enter = "Enter"
    let reEnter = "Re-Enter"
    let enterIFSC = "Enter IFSC"
    let enterYourBeneficiaryName = "Enter your Beneficiary name"
    let beneficiaryName = "Beneficiary name"
    let accountNumberMismatched = "Account Number Mismatched"
    let invalidIFSC = "Invalid IFSC"
    let cancelledChequeBankpassbook = "Cancelled cheque / bank passbook"
    let idProof = "ID Proof"
    let addressProof = "Address proof"
    let selectProof = "Select proof"
    let fileSizeMax = "File Size max 2mb"
    let accountNumber = "Account Number"
    let confirmAccountNumber = "Confirm account number"
    let ifscCode = "IFSC code"
    let upiID = "UPI ID"
    let NETCUPI = "NETC UPI"
    let accountDetails = "Account details"
    let trackIssue = "Track Issues"
    let open = "Open"
    let closed = "Closed"
    let close = "Close"
    let customerSupport = "Customer support"
    let dobMasked = "XX XXX XXXX"
    
    let emailSettings = "Email Settings"
    let changeEmailID = "Change Email ID"
    let verifyAadharSubtitle = "For the security reason, We must verify your identity before adding a delivery address."
    let enterYourAAdhar = "Enter your Aadhaar number"
    let placeholderAadhar = "0000 0000 0000"
    let terms = "I agree to the Aadhaar Consent Policy"
    let continueText = "Continue"
    let verify = "Verify"
    let verified = "Verified"
    let verifyAadhar = "Verify Aadhar"
    let otpForAadhar = "OTP sent to your Aadhaar registered mobile number"
    let enterOTP = "Enter OTP"
    let enterEmailID = "Enter new Email ID"
    let emailPlaceholder = "abc@gmail.com"
    let reEnterEmailID = "Re-enter new Email ID"
    let secureEntryPlaceholder = "**************"
    let createNewMpin = "Create a new MPIN"
    let resetMpin = "Reset M-PIN"
    let enterNewMpin = "Enter new MPIN"
    
    let lockApp = "Lock app"
    let logoutInstead = "Log out instead"
    let logoutTitle = "Logout?"
    let logoutSubTitle = "Are you sure you want to logout?"
    let termsAndCondition = "Terms and Condition"
    let kycPolicy = "KYC Policy"
    let grievancePolicy = "Grievance Policy"
    let faq = "FAQ"
    let emptyMpinToast = "Enter MPIN is Empty"
    let invalidEmail = "Email Not valid"
    let emailUpdateSuccess = "Email ID updated successfully !"
    let mpinUpdateSuccess = "MPIN changed successfully! Login using New MPIN"
    let emailFailure = "Enter Valid Email"
    let emailMismatch = "Email Mismatch"
    let emailEmpty = "EmailField should not be empty"
    let acceptConsentPolicy = "Accept Consent Policy"
    let otpForResetMpin = "We’ve sent an OTP to +91"
    let toVerifyItsYou = "to verify it’s you."
    let aadharFailure = "Enter Valid Aadhar & Accept Consent Policy"
    let success = "Success"
    let failure = "Failure"
    let copied = "Copied"
    let securityAndPrivacySectionTitle = "Security and Privacy"
    let termsAndPolicySectionTitle =  "Terms of service and policy"
    let helpAndSupportSectionTitle = "Help and Support"
    let resetandForgetMpinRowTitle = "Reset MPIN"
    let biometricLoginRowTitle = "Biometric login"
    let termsandConditionRowTitle = "Terms and conditions"
    let kycPolicyRowTitle = "KYC Policy"
    let privacyPolicyRowTitle = "Privacy Policy"
    let grievancePolicyRowTitle = "Grievance Policy"
    let fAQRowTitle = "Frequently asked Question"
    let supportRowTitle = "Customer support"
    let trackIssueRowTitle = "Track issues"
    let accountClosureRowTitle = "Account Closure"
    let manageUPISettings = "Manage UPI & Settings"
    let createUPIID = "Create UPI ID"
    let viewQRCode = "View QR Code"
    let manageAccount = "Manage Account"
    let myMandates = "My Mandates"
    let myBeneficiaries = "My Beneficiaries"
    let blockedUser = "Blocked User"
    let viewDispute = "View Dispute"
    
    let vkycNote1 = "Keep your physical PAN & Aadhar cards ready"
    let vkycNote2 = "Ensure your have stable internet connectivity"
    let vkycNote3 = "A blank white sheet of paper and a black or blue pen for signature"
    // swiftlint:disable line_length
    let userConsentText = "Your video interaction with our staff will be in recording mode.\n\nA live photography will be captured during the vide interaction session with the staff.\n\nYour Aadhar details will be used for aadhar verification in V-CIP Process.\n\nYour live location will captured in V-CIP process.\n\nYou should ensure all the details are correct during the interaction session.\n\nThe Aadhar XML packet or Aadhar secure QR code should not be older than 3 days."
    // swiftlint:enable line_length
    let userConsent = "User Consent"
    let userConsentTermsText = "I agree by clicking this, for the above given information and proceed further."
    let continueToVideoKYC = "Continue to Video KYC"
    let verifyYourDetails = "Please verify your details"
    let vkyc = "VKYC"
    let videoVerification = "Video verification"
    let vkycSubTitle = "Keep below mentioned things ready before video KYC"
    let doThisLater = "I’ll do this later"
    let startVideoKyc = "Start Video KYC"
    let sessionTimeout = "Session Timeout"
    let okText = "OK"
    let notAvailable = "Not Available"
    let zeroAmount = "0.00"
    let noVehiclesFound = "No Vehicles Found"
    let noCardsFound = "No Cards found"
    let issue = "Issue"
    let transactionString = "Transaction"
    let downloadSuccess = "Downloaded Successfully"
    let fitmentSuccess = "Tag fitment certificate downloaded Successfully."
    
    let login = "Login"
    let tryAgain = "Try Again"
    let noInternetSubTitle = "It Seems like you are facing internet issue or technical glitch, try to sign in again."
    let noInternetTitle = "OOPS! \nNo internet connection"
    let sessionExpired = "Your session has expired"
    let sessionExpireDescription = "Your session has expired due to your inactivity. No worry, simply Login again"
    let vehicleScreenBottomMessageText = "Do you know? When you buy a new FasTag from QuikWallet, your vehicle gets automatically linked here!"
    let thanksForYourInterest = "Thanks for your interest"
    let kycSupportDescription = "For more details about KYC, please contact our customer support."
    
    let paymentSuccess = "Payment Successful!"
    let paymentSuccessDescription =  "Your payment got added successfully!"
    let paymentFailure = "Payment Failed!"
    let paymentFailureDesription = "An error occurred while processing your request"
    let tryOtherPaymentOption = "Try other Payment Option"
    let backToHome = "Back to Home"
    let vkycCompletedSuccessfully = "VKYC completed successfully!"
    let vkycCompletedDescription = "Your VKYC has been completed successfully. Your will get the updates soon."
    let cardBlocked = "Card Blocked"
    let cardBlockDescription = "Your card has been blocked permanently. Please reach out to customer support to unblock the card or apply new card"
    let enableCameraAndMicrophone = "Enable Camera and Microphone Access"
    let emailSendSuccess = "Email sent successfully"
    let walletBalanceMaximumLimit = "Wallet balance maximum limit is"
    let zeroAmountValidation = "Limit value should be greater than zero"
    let add = "Add"
    let errorSearchTitle = "Oops! Vehicle not found"
    let errorDescriptionLabel = "Sorry, it seems that the vehicle could not be found with this number. Please double-check the number and try again."
    let selectPaymentMethod = "Select Payment Method"
    let noUPIAppsFound = "No UPI apps found"
    let requestCallForBreak = "Request for call back"
    let continueForClosure = "Continue for closure"
    let whatWentWrong = "What Went Wrong"
    let gotIt = "Got it"
    let requestAccepted = "Request accepted"
    let callRequestDesc = "We have accepted your request. You can expect Call from us within 2 hours."
    let noIchangeButton = "No, I change my mind"
    let yesIWantToClose = "Yes, I want to close my account"
    let concernForCloseAccount = "I understand that closing my account will invalidate my FASTag(s), terminate all associated services, and I confirm that I have removed the FASTag from my vehicle(s)."
    let reasonForLeaving = "Reason for leaving ?"
    let gotToSupport = "Go to Support"
    let whatWentWrongDesc = """
    We're happy to help you. Please allow us to understand your concern.\n\n You can call us on 18003092225 or tap the button "Request for call back". Someone from QW team will assist you.
    """
    let closingAccountDesc = "Closing your account leads, FASTag and all the service associated with your account will no longer be valid."
    let closingAccountDescs2 = "This will impact your seamless journey as FASTag won't work at toll plazas."
    let sadToSeeTitle = "Sad to see you go"
    let chasisNumber = "Chassis Number"
    let registrationNumber = "Registration Number"
    let regPlaceHolder = "XX 00 XX 1234"
    let chasisPlaceHolder = "XXXX XXXX XXXX XXXX X"
    let regErrDescription = "Use the vehicle number associated with the purchase of this fastag."
    let chasisErrDescription = "Use the chassis number associated with the purchase of this fastag."
    let fasttagDetails = "FasTag Details"
    let qWFASTagFeedetails = "QW FASTag fee details"
    let tagIssuanceFee  = "Tag issuance fee"
    let gstPercentage   = "Gst (5%)"
    let fastTagBalance = "FASTag balance"
    let total   = "Total"
    let change = "Change"
    let deliveryAddress = "Delivery Address"
    let enterPinCode = "Enter PIN Code"
    let city = "City"
    let state = "State"
    let addressLine01 = "Address Line 01"
    let addressLine02 = "Address Line 02"
    let sendFastTagHere = "Send FASTag here"
    let addAddressInfo = "Give us Your address and we’ ll send your FASTag Over"
    let selectVehicleType = "Select vehicle type"
    let enterRegNumber = "Enter Registeration Number"
    let enterChasisNumber = "Enter Chassis Number"
    let vehicleClassTitle = "Vehicle class *"
    let vehicleVerification = "Vehicle Verification"
    let quikPayment = "Quik Payment"
    let quickPaymentDescription = "Make a payment with just one click using your wallet balance."
    let payViaWallet = "Pay via QWallet"
    let moneyTransferViaUPI = "Money Transfer via UPI"
    let myUPIID = "My UPI ID:"
    let payUPIID = "Pay\nUPI ID"
    let bankTransfer = "Bank\nTransfer"
    let requestMoney = "Request\nMoney"
    let transactionHistoryTitle = "Transaction\nHistory"
    let scanAndPay = "Scan and\nPay"
    let verifyYourIdentity = "Verify your \nIdentity..."
    let verifyYourIdentityDescription = "Keep below mentioned things ready before Verification"
    let verifyYourIdentityDescriptionOne = "Your own Aadhaar number"
    let verifyYourIdentityDescriptionTwo = "Phone Linked to Your Aadhar for OTP"
    let startVerification = "Start verification"
    let getStarted = "Get Started"
    let balance = "Balance:"
}

// MARK: API Status
struct APIStatus {
    static let statusString = APIStatus()
    let success = "success"
    let failed = "failed"
    let error = "error"
}

// MARK: WebView Url
struct WebViewUrl {
    static let urlString = WebViewUrl()
    let faq = "https://livquik.com/faq/"
    let termsAndConditions = "https://livquik.com/ppi/terms-and-conditions/"
    let greivancePolicy = "https://livquik.com/ppi/grievance-policy/"
    let disputePolicy = "https://livquik.com/payment-aggregator/dispute-resolution-policy/"
    let privacyPolicy = "https://livquik.com/ppi/privacy-policy/"
}

// MARK: StatusCodes
struct StatusCode {
    static let code = StatusCode()
    let sessionTimeout = 401
    let success = 200
}

// MARK: PaymentType
struct PaymentType {
    static let status = PaymentType()
    let credit = "credit"
    let debit = "debit"
}

// MARK: TrackIssue Data
struct TrackIssueStatus {
    static let status = TrackIssueStatus()
    let resolved = "resolved"
}

// MARK: Image String
struct Image {
    static let imageString = Image()
    let camera = "camera"
    let device = "device"
    let location = "location"
    let sms = "sms"
    let storage = "storage"
    let biometric = "biometric"
    let eyeClose = "eye_close"
    let eyeOpen = "eye_open"
    let dropdownDown = "dropdown_down"
    let dropdownUp = "dropdown_up"
    let calender = "calender"
    let successTick = "success_tick"
    let profileSelected = "profile_selected"
    let profileUnselected = "profile_unselected"
    let cardSelected = "card_selected"
    let cardUnselected = "card_unselected"
    let homeSelected = "home_selected"
    let home = "home"
    let transactionSelected = "transaction_selected"
    let transaction = "transaction"
    let vehicleSelected = "vehicle_selected"
    let vehicle = "vehicle"
    let roundedBack = "roundedBack"
    let copyBg = "copyBg"
    let rightArrow = "rightArrow"
    let fillcheckBox = "fillcheckBox"
    let checkBox = "checkBox"
    let radioSelect = "radio_select"
    let radioUnselect = "radio_unselect"
    let managecardBg = "managecard_bg"
    let sessionExpired = "sessionExpired"
    let failureClose = "failureCLOSE"
    let cardBlocked = "cardBlocked"
    let eyeopendob = "eyeopen_dob"
    let eyeclosedob = "eyeclose_dob"
    let biometricColour = "biometric_colour"
    let faceid = "faceid"
    let toll = "toll"
    let recharge = "recharge"
    let filledGreenCheckBox = "filled_green_img"
    let upiCircle = "upi_circle"
    let scanPay = "scan_pay"
    let requestMoney = "request_money"
    let payUpiId = "pay_upi_id"
    let bankTransfer = "bank_transfer"
    let transactionHistory = "transaction_history"
    
}

// MARK: PayU Response
struct PayUResult {
    static let status = PayUResult()
    let success = "successPayU"
    let failure = "failurePayU"
}

// MARK: Card Status
struct CardStatus {
    static let status = CardStatus()
    let blocked = "blocked"
    let locked = "locked"
    let allocated = "allocated"
}

// MARK: M2PSDKDismissType Status
struct M2PSDKDismissType {
    static let status = M2PSDKDismissType()
    let sessionExpired = "SESSION_EXPIRED"
    let somethingWentWorng = "SOMETHING_WENTWORNG"
    let userClosed = "USER_CLOSED"
    let trackIssue = "TRACK_ISSUE"
    let permanentBlock = "PERMANENT_BLOCK_SUCCESS"
    let noInternet = "NO_INTERNET"
}

/*Text Toast*/
func showSuccessToastMessage(message: String, messageColor: UIColor = .white, bgColour: UIColor = .redErrorColor, position: ToastPosition = .center, duration: TimeInterval = 1.5) {
    DispatchQueue.main.async {
        var toastStyle = ToastStyle()
        toastStyle.backgroundColor = bgColour
        toastStyle.messageColor = messageColor
        toastStyle.displayShadow = false
        toastStyle.shadowColor = .black.withAlphaComponent(0.3)
        toastStyle.shadowOpacity = 1
        toastStyle.shadowRadius = 3.0
        toastStyle.shadowOffset = CGSize(width: 0, height: 1)
        ToastManager.shared.position = position
        ToastManager.shared.duration = duration
        ToastManager.shared.style = toastStyle
        UIApplication.shared.keyWindow?.make(toast: message)
    }
}
// MARK: Print Log
 func printLog(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}
