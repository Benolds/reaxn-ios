//
//  Constants.swift
//  ReaXn
//
//  Created by Benjamin Reynolds on 7/12/15.
//  Copyright (c) 2015 ReaXn. All rights reserved.
//

import Foundation

public class Constants {
    
    public static func DefaultsKey_ActionType() -> String {
        return "action_type"
    }
    public static func DefaultsKey_TwilioToPhoneNumber() -> String {
        return "twilio_to_phone_number"
    }
    public static func DefaultsKey_TwilioMessage() -> String {
        return "twilio_message"
    }
    
    // values for DefaultsKey_ActionType
    public static func DefaultsMessagesString() -> String {
        return "messages"
    }
    public static func DefaultsPhoneString() -> String {
        return "phone"
    }
    public static func DefaultsVoiceMemosString() -> String {
        return "voice_memos"
    }
    
    public static func TwilioSID() -> String {
        return "ACba74031ab5f7675cd18641412e5f4b54"
    }
    public static func TwilioSecret() -> String {
        return "16dd90718333f34e750a6c91ce499eb8"
    }
    public static func TwilioFromNumber() -> String {
        return "+16694004715"
    }
}