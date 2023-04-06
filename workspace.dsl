workspace {

    model {
        user = person "User"
        smartHomeSoftwareSystem = softwareSystem "Smart Home System" {
			applicationContainer = container "Smart Home Application" "Controls the ambient temperature and allows the user to monitor video and temperature readings" {
				temperatureManagementComponent = component "Temperature management" "Controls the ambient temperature based on temperature readings"
				videoCaptureComponent = component "Video Capture" "Stores video content to file system"
				userInterfaceComponent = component "User Interface" "Displays the temperature and video content" "" "Web browser"
			}
			databaseContainer = container "Database" "" "PostgreSQL schema" "Database, Infrastructure"
			rabbitMQContainer = container "MQTT Broker" "" "RabbitMQ" "MQTT Broker, Infrastructure"
			videoStoreContainer = container "Video Store" "Stores video content" "File system" "File system, Infrastructure"
		}
		thermometerSoftwareSystem = softwareSystem "Thermometer" "" "External"
		heatPumpSoftwareSystem = softwareSystem "Heat Pump" "" "External"
		cameraSoftwareSystem = softwareSystem "Camera" "" "External"

        user -> userInterfaceComponent "Uses"
		
		userInterfaceComponent -> databaseContainer "Reads temperature data"
		userInterfaceComponent -> videoStoreContainer "Reads video content"
		
		cameraSoftwareSystem -> videoCaptureComponent "Sends video content"
		
		videoCaptureComponent -> videoStoreContainer "Writes video content"
		
		thermometerSoftwareSystem -> rabbitMQContainer "Sends temperature readings" "MQTTP"
		
		temperatureManagementComponent -> rabbitMQContainer "Gets temperature readings" "MQTTP"
		temperatureManagementComponent -> databaseContainer "Reads/Writes temperature readings"
		temperatureManagementComponent -> heatPumpSoftwareSystem "Controls the ambient temperature"		
    }

    views {
        systemContext smartHomeSoftwareSystem {
            include *
            autoLayout
        }
		container smartHomeSoftwareSystem {
			include *
            autoLayout
		}
		component applicationContainer {
			include *
            autoLayout
		}
		
		theme default
		
		styles {
		  element "External" {
			background #999999
		  }
		  element "Infrastructure" {
			background #c96565
		  }
		  element "Web browser" {
			shape WebBrowser
		  }
		  element "Database" {
			shape Cylinder
		  }
		  element "File system" {
			shape Folder
		  }
		  element "MQTT Broker" {
			shape Pipe
		  }
		  relationship "Relationship" {
			style dotted
		  }
		}

    }
}