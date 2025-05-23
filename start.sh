#!/usr/bin/env bash
echo "starting script"

# Loading env variables

export $(grep -v '^#' .env | xargs)

# echo ""
# echo "Loading azd .env file from current environment"
# echo ""

# while IFS='=' read -r key value; do
#     value=$(echo "$value" | sed 's/^"//' | sed 's/"$//')
#     export "$key=$value"
# done <<EOF
# $(azd env get-values)
# EOF

# if [ $? -ne 0 ]; then
#     echo "Failed to load environment variables from azd environment"
#     exit $?
# fi

echo 'Creating python virtual environment "backend/backend_env"'
python3 -m venv backend/backend_env

echo ""
echo "Restoring backend python packages"
echo ""

cd backend
./backend_env/bin/python3 -m pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "Failed to restore backend python packages"
    exit $?
fi

echo ""
echo "Restoring frontend npm packages"
echo ""

cd ../frontend
npm install
if [ $? -ne 0 ]; then
    echo "Failed to restore frontend npm packages"
    exit $?
fi

echo ""
echo "Building frontend"
echo ""

npm run build
if [ $? -ne 0 ]; then
    echo "Failed to build frontend"
    exit $?
fi

echo ""
echo "Starting backend"
echo ""

cd ../backend
xdg-open http:/localhost:8000
./backend_env/bin/python3 ./app.py
if [ $? -ne 0 ]; then
    echo "Failed to start backend"
    exit $?
fi