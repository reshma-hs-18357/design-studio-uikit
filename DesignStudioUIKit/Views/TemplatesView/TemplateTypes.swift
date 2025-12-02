//
//  TemplatesViewController.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 13/11/25.
//

import UIKit

enum Templates: String, CaseIterable {
    case vendorPortal = "Vendor Portal"
    case orderManagement = "Order Management"
    case tractorCustomerPortal = "Customer Portal - Tractor"
    case charityPublicPortal = "Public Portal - Charity"
    case logisticsVendor = "Logistics Vendor"
    case test = "Auto Layout"
    case individual = "Individual Element"
    case demo = "Demo"
    
    var pageTypes: [(pageName: String, jsonSource: String)] {
        switch self {
        case .vendorPortal:
            return [
                (pageName: "Sign In" , jsonSource: "VP_Login"),
                (pageName: "Sign up" , jsonSource: "VP_SignUp"),
                (pageName: "Reset Password" , jsonSource: "VP_ResetPassword"),
                (pageName: "Create Password" , jsonSource: "VP_CreatePassword"),
                (pageName: "Home" , jsonSource: "VP_Home"),
                (pageName: "About Us" , jsonSource: "VP_AboutUs"),
                (pageName: "Become Partner" , jsonSource: "VP_BecomePartner"),
            ]
        case .orderManagement:
            return [
                (pageName: "Sign In", jsonSource: "OM_SignIn"),
                (pageName: "Sign Up", jsonSource: "OM_SignUp"),
                (pageName: "Reset Password", jsonSource: "OM_ResetPassword"),
                (pageName: "Create Password", jsonSource: "OM_CreatePassword"),
                (pageName: "Home", jsonSource: "OM_Home"),
                (pageName: "Services", jsonSource: "OM_Services"),
                (pageName: "Menu", jsonSource: "OM_Menu"),
            ]
        case .tractorCustomerPortal:
            return [
                (pageName: "Sign In", jsonSource: "CP_SignIn"),
                (pageName: "Sign Up", jsonSource: "CP_SignUp"),
                (pageName: "Reset Password", jsonSource: "CP_ResetPassword"),
                (pageName: "Create Password", jsonSource: "CP_CreatePassword"),
                (pageName: "Home", jsonSource: "CP_Home"),
                (pageName: "Case Study", jsonSource: "CP_CaseStudy"),
                (pageName: "Research Lab", jsonSource: "CP_ResearchLab"),
            ]
        case .charityPublicPortal:
            return [
                (pageName: "Sign In" , jsonSource: "PP_SignIn"),
                (pageName: "Sign up" , jsonSource: "PP_SignUp"),
                (pageName: "Reset Password" , jsonSource: "PP_ResetPassword"),
                (pageName: "Create Password" , jsonSource: "PP_CreatePassword"),
                (pageName: "Home" , jsonSource: "PP_Home"),
                (pageName: "Who are we" , jsonSource: "PP_WhoAreWe"),
            ]
        case .logisticsVendor:
            return [
                (pageName: "Sign In" , jsonSource: "LV_SignIn"),
                (pageName: "Sign up" , jsonSource: "LV_SignUp"),
                (pageName: "Reset Password" , jsonSource: "LV_ResetPassword"),
                (pageName: "Create Password" , jsonSource: "LV_CreatePassword"),
                (pageName: "Home" , jsonSource: "LV_Home"),
                (pageName: "About Us" , jsonSource: "LV_AboutUs"),
            ]
        case .test:
            return [
                (pageName: "Vertical In Vertical" , jsonSource: "Vertical_Static"),
                (pageName: "Horizontal Static" , jsonSource: "Horizontal_Static"),
                (pageName: "Horizontal Wrap" , jsonSource: "Horizontal_Wrap"),
                (pageName: "Horizontal In Horizontal" , jsonSource: "Horizontal_In_Horizontal"),
                (pageName: "Horizontal NoWrap" , jsonSource: "Horizontal_NoWrap"),
                (pageName: "XYCoordinate Test" , jsonSource: "XYCoordinateTest"),
                (pageName: "HStack Wrap Image", jsonSource: "Horizontal_WrapImage"),
                (pageName: "Auto layout Testing Vetical", jsonSource: "AutoLayoutTesting"),
                (pageName: "Percentage Calc Testing", jsonSource: "Percent_Calc")
                
            ]
        case .individual:
            return [
                (pageName: "Image Only Element", jsonSource: "ImageOnlyView"),
                (pageName: "Text Only Element", jsonSource: "TextOnly"),
                (pageName: "XYCoordinate Element", jsonSource: "XYCoordinateOnlyTest"),
                (pageName: "Vertical Primitive Text", jsonSource: "VerticalStackOnly"),
                (pageName: "Vertical Complex Text", jsonSource: "VerticalComplex"),
                (pageName: "HorizontalStack Element", jsonSource: "HorizontalView"),
                (pageName: "Template Test", jsonSource: "TemplateText"),
                (pageName: "Template Test Without HS", jsonSource: "TemplateWithoutHS"),
                (pageName: "More Vertical Test", jsonSource: "MoreVerticalText"),
                (pageName: "Horizontal Test", jsonSource: "HorizontalTest"),
            ]
        case .demo:
            return [
                (pageName: "Vertical Only Demo", jsonSource: "VerticalOnlyDemo"),
                (pageName: "Horizontal Only Demo", jsonSource: "HorizontalOnlyDemo"),
            ]
            
        }
    }
}
