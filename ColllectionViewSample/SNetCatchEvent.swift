//
//  SNetCatchEvent.swift
//  ObjToSwiftMigration
//
//  Created by SHABEERALI K on 25/01/19.
//  Copyright © 2019 SHABEERALI K. All rights reserved.
//

import Foundation
import Foundation

let SNETCEvent = SNetCatchEvent.shareInstance()
enum OTTExceptionCode : Int {
    case ott_UNSECURY_HTTPS_CONNECTION = 2083
    case ott_SESSION_EXPIRED_AUTOLOGIN = 2084
    case ott_SESSION_EXPIRED_RELOGIN = 2085
    case ott_RECEIVE_ERROR_DATA_FORMAT = 2086
    case ott_NETWORK_DISCONNECTED = 2087
    case ott_SYSTEM_CANCEL_REQUEST = 2088
    case ott_NETWORK_SQM_REPORT = 2089
    case ott_SYSTEM_LOGIN_OCCASION = 2090
    case ott_SYSTEM_MEMORY_FAILED = 2091
    case ott_EXCEPTION_END
}

protocol SNetTaskUnifiedCallBackProtocol: NSObjectProtocol {
    /**
     * receive response successfuly
     
     @param aRsp a response
     @param aReq a request
     @param isCache caching or not
     */
    func successReceiveResponse(_ aRsp: OTTRspRef?, request aReq: OTTReqRef?, isCache: Bool)
}

/*!
 @class SNetTask
 @superclass NSObject
 @abstract This class is a network cache class
 
 */
class SNetCatchEvent: NSObject {
    /**
     Https certification verify disabled
     */
    var disableVerifyHttpsCert = false
    /**
     * the unified type confirmed SNetTaskUnifiedCallBackProtocol
     */
    var unified: SNetTaskUnifiedCallBackProtocol?
    
    /**
     * instance type
     
     @return Return to its own type value
     */
    override init() {
        //if super.init()
        disableVerifyHttpsCert = false
    }
    
    
    class func shareInstance() -> Self {
    }
    
    /**
     * register unified callback
     
     @param unifiled unifiled callback confirm SNetTaskUnifiedCallBackProtocol
     @return if SNetCache and param is nomarl return YES otherwise return NO
     */
    func registerUnifiledCallBack(_ unifiled: SNetTaskUnifiedCallBackProtocol?) -> Bool {
        if unifiled is SNetTaskUnifiedCallBackProtocol == nil {
            return false
        }
        unified = unifiled
        return true
    }
}
