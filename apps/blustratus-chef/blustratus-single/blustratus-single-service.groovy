/*******************************************************************************
* Copyright (c) 2012 GigaSpaces Technologies Ltd. All rights reserved
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*       http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/
service {
    extend "../../../services/chef"
    name "blustratus"
    type "APP_SERVER"
    icon "blustratus.png"
    numInstances 1

    compute {
        template "MEDIUM_RH"
    }

    lifecycle {
		
		details {
			def currPublicIP = context.publicAddress
			def bluStratusURL = "https://${currPublicIP}:8443"
			def bluStratusUser = "bluadmin"
			def bluStratusPass = "passw0rd"
			
			def cognosURL = "https://${currPublicIP}/ibmcognos"
			def cognosUser1 = "db2inst1"
			def cognosPass1 = "passw0rd"			
			
			def cognosUser2 = "bluadmin"
			def cognosPass2 = "passw0rd"			
			
			println "blustratus-single-service.groovy: bluStratusURL is ${bluStratusURL}"
			println "blustratus-single-service.groovy: bluStratusUser is ${bluStratusUser}"
			println "blustratus-single-service.groovy: bluStratusPass is ${bluStratusPass}"
			
			println "blustratus-single-service.groovy: cognosURL is ${cognosURL}"
			println "blustratus-single-service.groovy: cognosUser1 is ${cognosUser1}"
			println "blustratus-single-service.groovy: cognosPass1 is ${cognosPass1}"
			println "blustratus-single-service.groovy: cognosUser2 is ${cognosUser2}"
			println "blustratus-single-service.groovy: cognosPass2 is ${cognosPass2}"			
			
			return [
				"bluStratusURL":"<a href=\"${bluStratusURL}\" target=\"_blank\">${bluStratusURL}</a>" ,
				"bluStratusUser":"${bluStratusUser}" , 
				"bluStratusPass":"${bluStratusPass}" ,
				"cognosURL":"<a href=\"${cognosURL}\" target=\"_blank\">${cognosURL}</a>" ,
				"cognosUser1":"${cognosUser1}" , 
				"cognosPass1":"${cognosPass1}" ,
				"cognosUser2":"${cognosUser2}" , 
				"cognosPass2":"${cognosPass2}"				
			]
		}
	
	
        startDetectionTimeoutSecs 1240
        startDetection {
            ServiceUtils.isPortOccupied(System.getenv()["CLOUDIFY_AGENT_ENV_PRIVATE_IP"], 389)
        }
    }
}
