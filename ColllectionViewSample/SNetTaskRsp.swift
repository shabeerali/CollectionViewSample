//
//  SNetTaskRsp.swift
//  ObjToSwiftMigration
//
//  Created by SHABEERALI K on 24/01/19.
//  Copyright © 2019 SHABEERALI K. All rights reserved.
//

import Foundation
class SNetTaskRsp: MsaAccessResponse {
    /**
     * OTT response
     */
    var ottRsp: OTTRspRef?
    func success() -> Bool {
        return result.retCode == "000000000"
    }
    
    func rspCode() -> String? {
        return result.retCode
    }
}


