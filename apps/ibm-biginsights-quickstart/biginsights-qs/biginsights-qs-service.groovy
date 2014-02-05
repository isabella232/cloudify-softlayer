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
    name "biginsights"
    type "APP_SERVER"
    icon "biginsights.png"
    numInstances 1

    compute {
        template "LARGE_RH"
    }

    lifecycle {
		
		details {
			def currPublicIP = context.publicAddress
			def biginsightsURL = "https://${currPublicIP}:${httpPort}"
			def biginsightsDfsHealthURL = "https://${currPublicIP}:${nameNodePort}"
			def biginsightsUser = "biadmin"
			def biginsightsPass = "biadmin"
			
			
			println "biginsights-service.groovy: biginsightsURL is ${biginsightsURL}"
			println "biginsights-service.groovy: biginsightsDfsHealthURL is ${biginsightsDfsHealthURL}"
			println "biginsights-service.groovy: biginsightsUser is ${biginsightsUser}"
			println "biginsights-service.groovy: biginsightsPass is ${biginsightsPass}"
			
			
			return [
				"biginsights URL":"<a href=\"${biginsightsURL}\" target=\"_blank\">${biginsightsURL}</a>" ,
				"biginsights DFS Health URL":"<a href=\"${biginsightsDfsHealthURL}\" target=\"_blank\">${biginsightsDfsHealthURL}</a>" ,
				"biginsightsUser":"${biginsightsUser}" , 
				"biginsightsPass":"${biginsightsPass}" ,
			]
		}
	
	
        startDetectionTimeoutSecs 1240
        startDetection {
			ServiceUtils.isPortOccupied(nameNodePort)
        }
		
		locator {	
			def sigarQuery = "State.Name.eq=java,Args.*.ew=${nameNodeJmxPort}"
			println "biginsights-qs-service(locator): Sigar query is ${sigarQuery}"
			def myPids = ServiceUtils.ProcessUtils.getPidsWithQuery(sigarQuery)			
			println "biginsights-qs-service(locator): Current PIDs are ${myPids}"
			return myPids
        }
    }
}
