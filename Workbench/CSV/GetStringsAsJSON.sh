#!/bin/bash

# codestep-A1996372-5955-4187-B5EA-435383DB1F08 CSV Build phase

SWIFT_FILE=/tmp/workbench.csv.swift
SELECT_COLUMN=$1
URL="https://docs.google.com/spreadsheets/d/e/2PACX-1vQsprRxOtY7tVC2GsVtsu-hYzbwMCrQJV6TuQUss4az-YjavOt2Dhu0DRcvGhFKA5HriHHBIlkNfeS1/pub?gid=464418893&single=true&output=csv"

# Prepend some "includes"
cat Workbench/Dynamo/AppConfig.swift \
    Workbench/Dynamo/Debug.swift \
    Workbench/Dynamo/Extensions/Data+Extensions.swift \
    Workbench/Dynamo/NetworkOperation.swift \
    Workbench/Dynamo/Classes/CSVReader.swift > $SWIFT_FILE

# Add the code to get the CSV file and convert to JSON
cat <<EOF >> $SWIFT_FILE

AppConfig.debug = false

if let url = URL(string: "$URL") {
    NetworkOperation(request: URLRequest(url: url)) { (data, response, _) in
        let httpResponse = response as? HTTPURLResponse
        if let code = httpResponse?.statusCode,
            code == 200,
            let data = data,
            let string = String(data: data, encoding: .utf8) {
            let items = csvReadLookup(string: string, keyName: "id", valueName: "$SELECT_COLUMN")
            if let json = Data.JSON(items) {
                print("\(String(data: json, encoding: .utf8)!)")
            }
        }
        exit(0)
    }.queue()
}

dispatchMain()

EOF

# Run it
swift $SWIFT_FILE
