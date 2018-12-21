//  Created by Helge Hess on 21.12.18.
//  Copyright © 2018 ZeeZide GmbH. All rights reserved.

import Foundation

@dynamicMemberLookup
public struct EnvironmentTrampoline {
    
    public subscript(dynamicMember k: String) -> String? {
        return ProcessInfo.processInfo.environment[k]
    }
}
