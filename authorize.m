function token = authorize(additional)
    clientID="a9c82462bc23488e88194dd0402f92e6";
    clientSecret="1177ca3c5a244ec7bf9badb73f089a6c";
    method=matlab.net.http.RequestMethod.POST;
    contentTypeField = matlab.net.http.field.ContentTypeField('application/x-www-form-urlencoded');
    b64=matlab.net.base64encode(clientID+":"+clientSecret);
    authorizationField=matlab.net.http.field.GenericField("Authorization",strcat("Basic ",b64));
    header=[contentTypeField authorizationField];
    formField = matlab.net.http.MessageBody("grant_type="+additional);
    request = matlab.net.http.RequestMessage(method,header,formField);
    uri="https://accounts.spotify.com/api/token";
    resp=send(request,uri);
    token=resp.Body.Data.access_token;
end

