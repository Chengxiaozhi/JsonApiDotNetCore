#!/bin/bash
# generates ./request-examples documents

function cleanup() {
    kill -9 $(lsof -ti tcp:5001) &2>/dev/null
}

cleanup
dotnet run -p ../src/Examples/GettingStarted/GettingStarted.csproj &
app_pid=$!


{ # try
    echo "Started app with PID $app_pid"

    sleep 5

    echo "sleep over"

    for path in ./request-examples/*.sh; do
        op_name=$(basename "$path" .sh | sed 's/.*-//')
        echo $op_name
        bash $path | jq . > "./request-examples/$op_name-Response.json"
    done
}

# docfx metadata

cleanup
