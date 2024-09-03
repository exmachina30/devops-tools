import requests
import os

environ = os.environ

url_token = f'{environ["BASE_URL"]}/lorem/ipsum' 

headers1 = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': f'Basic {CLIENT_CREDS}' 
}

data = {
    'grant_type': 'password',
    'username': 'xxx', 
    'password': 'xxx'   
}

response_token = requests.post(url_token, headers=headers1, data=data)

if response_token.headers.get('Content-Type') == 'application/json':
    try:
        response_dict = response_token.json()
        access_token = response_dict.get("access_token")
        if access_token:
            print(f"Access Token: {access_token}")
        else:
            print("Access token not found in response")
    except ValueError:
        print("Response is not valid JSON")
else:
    print("Response is not in JSON format")

if access_token:
    headers2 = {
        'accept': 'application/json',
        'Authorization': f'Bearer {access_token}'  
    }
    
    second_url = f'{environ["BASE_URL"]}/lorem/ipsum'
    
    response_delete = requests.get(second_url, headers=headers2)
    
    print(f"Delete xxx request status code: {response_delete.status_code}")
    print(f"Delete xxx response: {response_delete.json()}")
else:
    print("Cannot proceed with the second request as access token is not available")