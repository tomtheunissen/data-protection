# ZAP by Checkmarx Scanning Report

ZAP by [Checkmarx](https://checkmarx.com/).


## Summary of Alerts

| Risk Level | Number of Alerts |
| --- | --- |
| High | 3 |
| Medium | 7 |
| Low | 8 |
| Informational | 8 |




## Insights

| Level | Reason | Site | Description | Statistic |
| --- | --- | --- | --- | --- |
| Low | Warning |  | ZAP errors logged - see the zap.log file for details | 2    |
| Low | Warning |  | ZAP warnings logged - see the zap.log file for details | 64    |
| Info | Informational |  | Percentage of network failures | 2 % |
| Info | Informational | https://20.8.94.69 | Percentage of responses with status code 2xx | 74 % |
| Info | Informational | https://20.8.94.69 | Percentage of responses with status code 3xx | 2 % |
| Info | Informational | https://20.8.94.69 | Percentage of responses with status code 4xx | 22 % |
| Info | Informational | https://20.8.94.69 | Percentage of endpoints with content type image/png | 4 % |
| Info | Informational | https://20.8.94.69 | Percentage of endpoints with content type image/vnd.microsoft.icon | 2 % |
| Info | Informational | https://20.8.94.69 | Percentage of endpoints with content type text/css | 2 % |
| Info | Informational | https://20.8.94.69 | Percentage of endpoints with content type text/html | 82 % |
| Info | Informational | https://20.8.94.69 | Percentage of endpoints with content type text/javascript | 6 % |
| Info | Informational | https://20.8.94.69 | Percentage of endpoints with content type text/plain | 2 % |
| Info | Informational | https://20.8.94.69 | Percentage of endpoints with method GET | 87 % |
| Info | Informational | https://20.8.94.69 | Percentage of endpoints with method POST | 12 % |
| Info | Informational | https://20.8.94.69 | Count of total endpoints | 47    |
| Info | Informational | https://20.8.94.69 | Percentage of slow responses | 15 % |







## Alerts

| Name | Risk Level | Number of Instances |
| --- | --- | --- |
| Cross Site Scripting (DOM Based) | High | 2 |
| External Redirect | High | 1 |
| SQL Injection | High | 1 |
| Absence of Anti-CSRF Tokens | Medium | Systemic |
| CSP: Failure to Define Directive with No Fallback | Medium | 2 |
| CSP: Wildcard Directive | Medium | 2 |
| CSP: style-src unsafe-inline | Medium | 2 |
| Content Security Policy (CSP) Header Not Set | Medium | Systemic |
| Missing Anti-clickjacking Header | Medium | Systemic |
| Parameter Tampering | Medium | 1 |
| Cookie No HttpOnly Flag | Low | 1 |
| Cookie Without Secure Flag | Low | 1 |
| Cookie without SameSite Attribute | Low | 1 |
| In Page Banner Information Leak | Low | 1 |
| Private IP Disclosure | Low | 1 |
| Strict-Transport-Security Header Not Set | Low | Systemic |
| Timestamp Disclosure - Unix | Low | Systemic |
| X-Content-Type-Options Header Missing | Low | Systemic |
| Authentication Request Identified | Informational | 1 |
| GET for POST | Informational | 6 |
| Information Disclosure - Sensitive Information in URL | Informational | 2 |
| Information Disclosure - Suspicious Comments | Informational | 2 |
| Modern Web Application | Informational | Systemic |
| Re-examine Cache-control Directives | Informational | Systemic |
| User Agent Fuzzer | Informational | Systemic |
| User Controllable HTML Element Attribute (Potential XSS) | Informational | 8 |




## Alert Detail



### [ Cross Site Scripting (DOM Based) ](https://www.zaproxy.org/docs/alerts/40026/)



##### High (High)

### Description

Cross-site Scripting (XSS) is an attack technique that involves echoing attacker-supplied code into a user's browser instance. A browser instance can be a standard web browser client, or a browser object embedded in a software product such as the browser within WinAmp, an RSS reader, or an email client. The code itself is usually written in HTML/JavaScript, but may also extend to VBScript, ActiveX, Java, Flash, or any other browser-supported technology.
When an attacker gets a user's browser to execute his/her code, the code will run within the security context (or zone) of the hosting web site. With this level of privilege, the code has the ability to read, modify and transmit any sensitive data accessible by the browser. A Cross-site Scripted user could have his/her account hijacked (cookie theft), their browser redirected to another location, or possibly shown fraudulent content delivered by the web site they are visiting. Cross-site Scripting attacks essentially compromise the trust relationship between a user and the web site. Applications utilizing browser object instances which load content from the file system may execute code under the local machine zone allowing for system compromise.

There are three types of Cross-site Scripting attacks: non-persistent, persistent and DOM-based.
Non-persistent attacks and DOM-based attacks require a user to either visit a specially crafted link laced with malicious code, or visit a malicious web page containing a web form, which when posted to the vulnerable site, will mount the attack. Using a malicious form will oftentimes take place when the vulnerable resource only accepts HTTP POST requests. In such a case, the form can be submitted automatically, without the victim's knowledge (e.g. by using JavaScript). Upon clicking on the malicious link or submitting the malicious form, the XSS payload will get echoed back and will get interpreted by the user's browser and execute. Another technique to send almost arbitrary requests (GET and POST) is by using an embedded client, such as Adobe Flash.
Persistent attacks occur when the malicious code is submitted to a web site where it's stored for a period of time. Examples of an attacker's favorite targets often include message board posts, web mail messages, and web chat software. The unsuspecting user is not required to interact with any additional site/link (e.g. an attacker site or a malicious link sent via email), just simply view the web page containing the code.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_d/%23jaVasCript:/*-/*%60/*%5C%60/*'/*%22/**/(/*%20*/oNcliCk=alert(5397&29%20&29//%250D%250A%250d%250a//%3C/stYle/%3C/titLe/%3C/teXtarEa/%3C/scRipt/--!%3E%5Cx3csVg/%3CsVg/oNloAd=alert(5397&29//%3E%5Cx3e
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_d/`
  * Method: `GET`
  * Parameter: ``
  * Attack: `#jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert(5397) )//%0D%0A%0d%0a//</stYle/</titLe/</teXtarEa/</scRipt/--!>\x3csVg/<sVg/oNloAd=alert(5397)//>\x3e`
  * Evidence: ``
  * Other Info: `The following steps were done to trigger the DOM XSS:
With <PAYLOAD_0> as: #jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert(5397) )//%0D%0A%0d%0a//</stYle/</titLe/</teXtarEa/</scRipt/--!>\x3csVg/<sVg/oNloAd=alert(5397)//>\x3e
Access: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_d/<PAYLOAD_0>
Write to /html/body/div[1]/div[4]/div[1]/div/form/input the value: <PAYLOAD_0>
Click element: /html/body/div[1]/div[4]/div[1]/div/form/input
Access: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_d/<PAYLOAD_0>
Write to /html/body/div[1]/div[8]/input[1] the value: <PAYLOAD_0>
Click element: /html/body/div[1]/div[8]/input[1]
`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_d/%3Fdefault%3Fname=abc%23%3Cimg%20src=%22random.gif%22%20onerror=alert(5397&29%3E
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_d/ (default)`
  * Method: `GET`
  * Parameter: ``
  * Attack: `?name=abc#<img src="random.gif" onerror=alert(5397)>`
  * Evidence: ``
  * Other Info: `The following steps were done to trigger the DOM XSS:
With <PAYLOAD_0> as: ?name=abc#<img src="random.gif" onerror=alert(5397)>
Access: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_d/?default<PAYLOAD_0>
Write to /html/body/div[1]/div[4]/div[1]/div/form/input the value: <PAYLOAD_0>
Click element: /html/body/div[1]/div[4]/div[1]/div/form/input
`


Instances: 2

### Solution

Phase: Architecture and Design
Use a vetted library or framework that does not allow this weakness to occur or provides constructs that make this weakness easier to avoid.
Examples of libraries and frameworks that make it easier to generate properly encoded output include Microsoft's Anti-XSS library, the OWASP ESAPI Encoding module, and Apache Wicket.

Phases: Implementation; Architecture and Design
Understand the context in which your data will be used and the encoding that will be expected. This is especially important when transmitting data between different components, or when generating outputs that can contain multiple encodings at the same time, such as web pages or multi-part mail messages. Study all expected communication protocols and data representations to determine the required encoding strategies.
For any data that will be output to another web page, especially any data that was received from external inputs, use the appropriate encoding on all non-alphanumeric characters.
Consult the XSS Prevention Cheat Sheet for more details on the types of encoding and escaping that are needed.

Phase: Architecture and Design
For any security checks that are performed on the client side, ensure that these checks are duplicated on the server side, in order to avoid CWE-602. Attackers can bypass the client-side checks by modifying values after the checks have been performed, or by changing the client to remove the client-side checks entirely. Then, these modified values would be submitted to the server.

If available, use structured mechanisms that automatically enforce the separation between data and code. These mechanisms may be able to provide the relevant quoting, encoding, and validation automatically, instead of relying on the developer to provide this capability at every point where output is generated.

Phase: Implementation
For every web page that is generated, use and specify a character encoding such as ISO-8859-1 or UTF-8. When an encoding is not specified, the web browser may choose a different encoding by guessing which encoding is actually being used by the web page. This can cause the web browser to treat certain sequences as special, opening up the client to subtle XSS attacks. See CWE-116 for more mitigations related to encoding/escaping.

To help mitigate XSS attacks against the user's session cookie, set the session cookie to be HttpOnly. In browsers that support the HttpOnly feature (such as more recent versions of Internet Explorer and Firefox), this attribute can prevent the user's session cookie from being accessible to malicious client-side scripts that use document.cookie. This is not a complete solution, since HttpOnly is not supported by all browsers. More importantly, XMLHTTPRequest and other powerful browser technologies provide read access to HTTP headers, including the Set-Cookie header in which the HttpOnly flag is set.

Assume all input is malicious. Use an "accept known good" input validation strategy, i.e., use an allow list of acceptable inputs that strictly conform to specifications. Reject any input that does not strictly conform to specifications, or transform it into something that does. Do not rely exclusively on looking for malicious or malformed inputs (i.e., do not rely on a deny list). However, deny lists can be useful for detecting potential attacks or determining which inputs are so malformed that they should be rejected outright.

When performing input validation, consider all potentially relevant properties, including length, type of input, the full range of acceptable values, missing or extra inputs, syntax, consistency across related fields, and conformance to business rules. As an example of business rule logic, "boat" may be syntactically valid because it only contains alphanumeric characters, but it is not valid if you are expecting colors such as "red" or "blue."

Ensure that you perform input validation at well-defined interfaces within the application. This will help protect the application even if a component is reused or moved elsewhere.
	

### Reference


* [ https://owasp.org/www-community/attacks/xss/ ](https://owasp.org/www-community/attacks/xss/)
* [ https://cwe.mitre.org/data/definitions/79.html ](https://cwe.mitre.org/data/definitions/79.html)


#### CWE Id: [ 79 ](https://cwe.mitre.org/data/definitions/79.html)


#### WASC Id: 8

#### Source ID: 1

### [ External Redirect ](https://www.zaproxy.org/docs/alerts/20019/)



##### High (Medium)

### Description

URL redirectors represent common functionality employed by web sites to forward an incoming request to an alternate resource. This can be done for a variety of reasons and is often done to allow resources to be moved within the directory structure and to avoid breaking functionality for users that request the resource at its previous location. URL redirectors may also be used to implement load balancing, leveraging abbreviated URLs or recording outgoing links. It is this last implementation which is often used in phishing attacks as described in the example below. URL redirectors do not necessarily represent a direct security vulnerability but can be abused by attackers trying to social engineer victims into believing that they are navigating to a site other than the true destination.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/open_redirect/source/low.php%3Fredirect=https%253A%252F%252F1186092670205342715.owasp.org
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/open_redirect/source/low.php (redirect)`
  * Method: `GET`
  * Parameter: `redirect`
  * Attack: `https://1186092670205342715.owasp.org`
  * Evidence: `https://1186092670205342715.owasp.org`
  * Other Info: `The response contains a redirect in its Location header which allows an external Url to be set.`


Instances: 1

### Solution

Assume all input is malicious. Use an "accept known good" input validation strategy, i.e., use an allow list of acceptable inputs that strictly conform to specifications. Reject any input that does not strictly conform to specifications, or transform it into something that does. Do not rely exclusively on looking for malicious or malformed inputs (i.e., do not rely on a deny list). However, deny lists can be useful for detecting potential attacks or determining which inputs are so malformed that they should be rejected outright.

When performing input validation, consider all potentially relevant properties, including length, type of input, the full range of acceptable values, missing or extra inputs, syntax, consistency across related fields, and conformance to business rules. As an example of business rule logic, "boat" may be syntactically valid because it only contains alphanumeric characters, but it is not valid if you are expecting colors such as "red" or "blue."

Use an allow list of approved URLs or domains to be used for redirection.

Use an intermediate disclaimer page that provides the user with a clear warning that they are leaving your site. Implement a long timeout before the redirect occurs, or force the user to click on the link. Be careful to avoid XSS problems when generating the disclaimer page.

When the set of acceptable objects, such as filenames or URLs, is limited or known, create a mapping from a set of fixed input values (such as numeric IDs) to the actual filenames or URLs, and reject all other inputs.

For example, ID 1 could map to "/login.asp" and ID 2 could map to "https://www.example.com/". Features such as the ESAPI AccessReferenceMap provide this capability.

Understand all the potential areas where untrusted inputs can enter your software: parameters or arguments, cookies, anything read from the network, environment variables, reverse DNS lookups, query results, request headers, URL components, e-mail, files, databases, and any external systems that provide data to the application. Remember that such inputs may be obtained indirectly through API calls.

Many open redirect problems occur because the programmer assumed that certain inputs could not be modified, such as cookies and hidden form fields.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html)
* [ https://cwe.mitre.org/data/definitions/601.html ](https://cwe.mitre.org/data/definitions/601.html)


#### CWE Id: [ 601 ](https://cwe.mitre.org/data/definitions/601.html)


#### WASC Id: 38

#### Source ID: 1

### [ SQL Injection ](https://www.zaproxy.org/docs/alerts/40018/)



##### High (Medium)

### Description

SQL injection may be possible.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/ ()(btnSign,mtxMessage,txtName)`
  * Method: `POST`
  * Parameter: `btnSign`
  * Attack: `Sign Guestbook OR 1=1 -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [Sign Guestbook AND 1=1 -- ] and [Sign Guestbook OR 1=1 -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was NOT returned for the original parameter.
The vulnerability was detected by successfully retrieving more data than originally returned, by manipulating the parameter.`


Instances: 1

### Solution

Do not trust client side input, even if there is client side validation in place.
In general, type check all data on the server side.
If the application uses JDBC, use PreparedStatement or CallableStatement, with parameters passed by '?'
If the application uses ASP, use ADO Command Objects with strong type checking and parameterized queries.
If database Stored Procedures can be used, use them.
Do *not* concatenate strings into queries in the stored procedure, or use 'exec', 'exec immediate', or equivalent functionality!
Do not create dynamic SQL queries using simple string concatenation.
Escape all data received from the client.
Apply an 'allow list' of allowed characters, or a 'deny list' of disallowed characters in user input.
Apply the principle of least privilege by using the least privileged database user possible.
In particular, avoid using the 'sa' or 'db-owner' database users. This does not eliminate SQL injection, but minimizes its impact.
Grant the minimum database access that is necessary for the application.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)


#### CWE Id: [ 89 ](https://cwe.mitre.org/data/definitions/89.html)


#### WASC Id: 19

#### Source ID: 1

### [ Absence of Anti-CSRF Tokens ](https://www.zaproxy.org/docs/alerts/10202/)



##### Medium (Low)

### Description

No Anti-CSRF tokens were found in a HTML submission form.
A cross-site request forgery is an attack that involves forcing a victim to send an HTTP request to a target destination without their knowledge or intent in order to perform an action as the victim. The underlying cause is application functionality using predictable URL/form actions in a repeatable way. The nature of the attack is that CSRF exploits the trust that a web site has for a user. By contrast, cross-site scripting (XSS) exploits the trust that a user has for a web site. Like XSS, CSRF attacks are not necessarily cross-site, but they can be. Cross-site request forgery is also known as CSRF, XSRF, one-click attack, session riding, confused deputy, and sea surf.

CSRF attacks are effective in a number of situations, including:
    * The victim has an active session on the target site.
    * The victim is authenticated via HTTP auth on the target site.
    * The victim is on the same local network as the target site.

CSRF has primarily been used to perform an action against a target site using the victim's privileges, but recent techniques have been discovered to disclose information by gaining access to the response. The risk of information disclosure is dramatically increased when the target site is vulnerable to XSS, because XSS can be used as a platform for CSRF, allowing the attack to operate within the bounds of the same-origin policy.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form name="csp" method="POST">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 1: "include" ].`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form name="ping" action="#" method="post">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 1: "ip" "Submit" ].`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/upload/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/upload/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form enctype="multipart/form-data" action="#" method="POST">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 1: "MAX_FILE_SIZE" "Upload" "uploaded" ].`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form method="post">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 1: "" ].`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form method="post" name="guestform" ">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 1: "btnClear" "btnSign" "txtName" ].`

Instances: Systemic


### Solution

Phase: Architecture and Design
Use a vetted library or framework that does not allow this weakness to occur or provides constructs that make this weakness easier to avoid.
For example, use anti-CSRF packages such as the OWASP CSRFGuard.

Phase: Implementation
Ensure that your application is free of cross-site scripting issues, because most CSRF defenses can be bypassed using attacker-controlled script.

Phase: Architecture and Design
Generate a unique nonce for each form, place the nonce into the form, and verify the nonce upon receipt of the form. Be sure that the nonce is not predictable (CWE-330).
Note that this can be bypassed using XSS.

Identify especially dangerous operations. When the user performs a dangerous operation, send a separate confirmation request to ensure that the user intended to perform that operation.
Note that this can be bypassed using XSS.

Use the ESAPI Session Management control.
This control includes a component for CSRF.

Do not use the GET method for any request that triggers a state change.

Phase: Implementation
Check the HTTP Referer header to see if the request originated from an expected page. This could break legitimate functionality, because users or proxies may have disabled sending the Referer for privacy reasons.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)
* [ https://cwe.mitre.org/data/definitions/352.html ](https://cwe.mitre.org/data/definitions/352.html)


#### CWE Id: [ 352 ](https://cwe.mitre.org/data/definitions/352.html)


#### WASC Id: 9

#### Source ID: 3

### [ CSP: Failure to Define Directive with No Fallback ](https://www.zaproxy.org/docs/alerts/10055/)



##### Medium (High)

### Description

The Content Security Policy fails to define one of the directives that has no fallback. Missing/excluding them is the same as allowing anything.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/`
  * Method: `GET`
  * Parameter: `Content-Security-Policy`
  * Attack: ``
  * Evidence: `script-src 'self' https://pastebin.com hastebin.com www.toptal.com example.com code.jquery.com https://ssl.google-analytics.com unpkg.com cdn.jsdelivr.net digi.ninja ;`
  * Other Info: `The directive(s): frame-ancestors, form-action is/are among the directives that do not fallback to default-src.`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/ ()(include)`
  * Method: `POST`
  * Parameter: `Content-Security-Policy`
  * Attack: ``
  * Evidence: `script-src 'self' https://pastebin.com hastebin.com www.toptal.com example.com code.jquery.com https://ssl.google-analytics.com unpkg.com cdn.jsdelivr.net digi.ninja ;`
  * Other Info: `The directive(s): frame-ancestors, form-action is/are among the directives that do not fallback to default-src.`


Instances: 2

### Solution

Ensure that your web server, application server, load balancer, etc. is properly configured to set the Content-Security-Policy header.

### Reference


* [ https://www.w3.org/TR/CSP/ ](https://www.w3.org/TR/CSP/)
* [ https://caniuse.com/#search=content+security+policy ](https://caniuse.com/#search=content+security+policy)
* [ https://content-security-policy.com/ ](https://content-security-policy.com/)
* [ https://github.com/HtmlUnit/htmlunit-csp ](https://github.com/HtmlUnit/htmlunit-csp)
* [ https://web.dev/articles/csp#resource-options ](https://web.dev/articles/csp#resource-options)


#### CWE Id: [ 693 ](https://cwe.mitre.org/data/definitions/693.html)


#### WASC Id: 15

#### Source ID: 3

### [ CSP: Wildcard Directive ](https://www.zaproxy.org/docs/alerts/10055/)



##### Medium (High)

### Description

Content Security Policy (CSP) is an added layer of security that helps to detect and mitigate certain types of attacks. Including (but not limited to) Cross Site Scripting (XSS), and data injection attacks. These attacks are used for everything from data theft to site defacement or distribution of malware. CSP provides a set of standard HTTP headers that allow website owners to declare approved sources of content that browsers should be allowed to load on that page — covered types are JavaScript, CSS, HTML frames, fonts, images and embeddable objects such as Java applets, ActiveX, audio and video files.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/`
  * Method: `GET`
  * Parameter: `Content-Security-Policy`
  * Attack: ``
  * Evidence: `script-src 'self' https://pastebin.com hastebin.com www.toptal.com example.com code.jquery.com https://ssl.google-analytics.com unpkg.com cdn.jsdelivr.net digi.ninja ;`
  * Other Info: `The following directives either allow wildcard sources (or ancestors), are not defined, or are overly broadly defined:
style-src, img-src, connect-src, frame-src, font-src, media-src, object-src, manifest-src`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/ ()(include)`
  * Method: `POST`
  * Parameter: `Content-Security-Policy`
  * Attack: ``
  * Evidence: `script-src 'self' https://pastebin.com hastebin.com www.toptal.com example.com code.jquery.com https://ssl.google-analytics.com unpkg.com cdn.jsdelivr.net digi.ninja ;`
  * Other Info: `The following directives either allow wildcard sources (or ancestors), are not defined, or are overly broadly defined:
style-src, img-src, connect-src, frame-src, font-src, media-src, object-src, manifest-src`


Instances: 2

### Solution

Ensure that your web server, application server, load balancer, etc. is properly configured to set the Content-Security-Policy header.

### Reference


* [ https://www.w3.org/TR/CSP/ ](https://www.w3.org/TR/CSP/)
* [ https://caniuse.com/#search=content+security+policy ](https://caniuse.com/#search=content+security+policy)
* [ https://content-security-policy.com/ ](https://content-security-policy.com/)
* [ https://github.com/HtmlUnit/htmlunit-csp ](https://github.com/HtmlUnit/htmlunit-csp)
* [ https://web.dev/articles/csp#resource-options ](https://web.dev/articles/csp#resource-options)


#### CWE Id: [ 693 ](https://cwe.mitre.org/data/definitions/693.html)


#### WASC Id: 15

#### Source ID: 3

### [ CSP: style-src unsafe-inline ](https://www.zaproxy.org/docs/alerts/10055/)



##### Medium (High)

### Description

Content Security Policy (CSP) is an added layer of security that helps to detect and mitigate certain types of attacks. Including (but not limited to) Cross Site Scripting (XSS), and data injection attacks. These attacks are used for everything from data theft to site defacement or distribution of malware. CSP provides a set of standard HTTP headers that allow website owners to declare approved sources of content that browsers should be allowed to load on that page — covered types are JavaScript, CSS, HTML frames, fonts, images and embeddable objects such as Java applets, ActiveX, audio and video files.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/`
  * Method: `GET`
  * Parameter: `Content-Security-Policy`
  * Attack: ``
  * Evidence: `script-src 'self' https://pastebin.com hastebin.com www.toptal.com example.com code.jquery.com https://ssl.google-analytics.com unpkg.com cdn.jsdelivr.net digi.ninja ;`
  * Other Info: `style-src includes unsafe-inline.`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/ ()(include)`
  * Method: `POST`
  * Parameter: `Content-Security-Policy`
  * Attack: ``
  * Evidence: `script-src 'self' https://pastebin.com hastebin.com www.toptal.com example.com code.jquery.com https://ssl.google-analytics.com unpkg.com cdn.jsdelivr.net digi.ninja ;`
  * Other Info: `style-src includes unsafe-inline.`


Instances: 2

### Solution

Ensure that your web server, application server, load balancer, etc. is properly configured to set the Content-Security-Policy header.

### Reference


* [ https://www.w3.org/TR/CSP/ ](https://www.w3.org/TR/CSP/)
* [ https://caniuse.com/#search=content+security+policy ](https://caniuse.com/#search=content+security+policy)
* [ https://content-security-policy.com/ ](https://content-security-policy.com/)
* [ https://github.com/HtmlUnit/htmlunit-csp ](https://github.com/HtmlUnit/htmlunit-csp)
* [ https://web.dev/articles/csp#resource-options ](https://web.dev/articles/csp#resource-options)


#### CWE Id: [ 693 ](https://cwe.mitre.org/data/definitions/693.html)


#### WASC Id: 15

#### Source ID: 3

### [ Content Security Policy (CSP) Header Not Set ](https://www.zaproxy.org/docs/alerts/10038/)



##### Medium (High)

### Description

Content Security Policy (CSP) is an added layer of security that helps to detect and mitigate certain types of attacks, including Cross Site Scripting (XSS) and data injection attacks. These attacks are used for everything from data theft to site defacement or distribution of malware. CSP provides a set of standard HTTP headers that allow website owners to declare approved sources of content that browsers should be allowed to load on that page — covered types are JavaScript, CSS, HTML frames, fonts, images and embeddable objects such as Java applets, ActiveX, audio and video files.

* URL: https://20.8.94.69/portaal/dvwa/
  * Node Name: `https://20.8.94.69/portaal/dvwa/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/index.php
  * Node Name: `https://20.8.94.69/portaal/dvwa/index.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution

Ensure that your web server, application server, load balancer, etc. is configured to set the Content-Security-Policy header.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP)
* [ https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html)
* [ https://www.w3.org/TR/CSP/ ](https://www.w3.org/TR/CSP/)
* [ https://w3c.github.io/webappsec-csp/ ](https://w3c.github.io/webappsec-csp/)
* [ https://web.dev/articles/csp ](https://web.dev/articles/csp)
* [ https://caniuse.com/#feat=contentsecuritypolicy ](https://caniuse.com/#feat=contentsecuritypolicy)
* [ https://content-security-policy.com/ ](https://content-security-policy.com/)


#### CWE Id: [ 693 ](https://cwe.mitre.org/data/definitions/693.html)


#### WASC Id: 15

#### Source ID: 3

### [ Missing Anti-clickjacking Header ](https://www.zaproxy.org/docs/alerts/10020/)



##### Medium (Medium)

### Description

The response does not protect against 'ClickJacking' attacks. It should include either Content-Security-Policy with 'frame-ancestors' directive or X-Frame-Options.

* URL: https://20.8.94.69/portaal/dvwa/
  * Node Name: `https://20.8.94.69/portaal/dvwa/`
  * Method: `GET`
  * Parameter: `x-frame-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/index.php
  * Node Name: `https://20.8.94.69/portaal/dvwa/index.php`
  * Method: `GET`
  * Parameter: `x-frame-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/`
  * Method: `GET`
  * Parameter: `x-frame-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/`
  * Method: `GET`
  * Parameter: `x-frame-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/fi/%3Fpage=include.php
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/fi/ (page)`
  * Method: `GET`
  * Parameter: `x-frame-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution

Modern Web browsers support the Content-Security-Policy and X-Frame-Options HTTP headers. Ensure one of them is set on all web pages returned by your site/app.
If you expect the page to be framed only by pages on your server (e.g. it's part of a FRAMESET) then you'll want to use SAMEORIGIN, otherwise if you never expect the page to be framed, you should use DENY. Alternatively consider implementing Content Security Policy's "frame-ancestors" directive.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/X-Frame-Options ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/X-Frame-Options)


#### CWE Id: [ 1021 ](https://cwe.mitre.org/data/definitions/1021.html)


#### WASC Id: 15

#### Source ID: 3

### [ Parameter Tampering ](https://www.zaproxy.org/docs/alerts/40008/)



##### Medium (Low)

### Description

Parameter manipulation caused an error page or Java stack trace to be displayed. This indicated lack of exception handling and potential areas for further exploit.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/fi/%3Fpage=
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/fi/ (page)`
  * Method: `GET`
  * Parameter: `page`
  * Attack: ``
  * Evidence: ` on line <b>`
  * Other Info: ``


Instances: 1

### Solution

Identify the cause of the error and fix it. Do not trust client side input and enforce a tight check in the server side. Besides, catch the exception properly. Use a generic 500 error page for internal server error.

### Reference



#### CWE Id: [ 472 ](https://cwe.mitre.org/data/definitions/472.html)


#### WASC Id: 20

#### Source ID: 1

### [ Cookie No HttpOnly Flag ](https://www.zaproxy.org/docs/alerts/10010/)



##### Low (Medium)

### Description

A cookie has been set without the HttpOnly flag, which means that the cookie can be accessed by JavaScript. If a malicious script can be run on this page then the cookie will be accessible and can be transmitted to another site. If this is a session cookie then session hijacking may be possible.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/`
  * Method: `POST`
  * Parameter: `dvwaSession`
  * Attack: ``
  * Evidence: `Set-Cookie: dvwaSession`
  * Other Info: ``


Instances: 1

### Solution

Ensure that the HttpOnly flag is set for all cookies.

### Reference


* [ https://owasp.org/www-community/HttpOnly ](https://owasp.org/www-community/HttpOnly)


#### CWE Id: [ 1004 ](https://cwe.mitre.org/data/definitions/1004.html)


#### WASC Id: 13

#### Source ID: 3

### [ Cookie Without Secure Flag ](https://www.zaproxy.org/docs/alerts/10011/)



##### Low (Medium)

### Description

A cookie has been set without the secure flag, which means that the cookie can be accessed via unencrypted connections.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/`
  * Method: `POST`
  * Parameter: `dvwaSession`
  * Attack: ``
  * Evidence: `Set-Cookie: dvwaSession`
  * Other Info: ``


Instances: 1

### Solution

Whenever a cookie contains sensitive information or is a session token, then it should always be passed using an encrypted channel. Ensure that the secure flag is set for cookies containing such sensitive information.

### Reference


* [ https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/06-Session_Management_Testing/02-Testing_for_Cookies_Attributes.html ](https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/06-Session_Management_Testing/02-Testing_for_Cookies_Attributes.html)


#### CWE Id: [ 614 ](https://cwe.mitre.org/data/definitions/614.html)


#### WASC Id: 13

#### Source ID: 3

### [ Cookie without SameSite Attribute ](https://www.zaproxy.org/docs/alerts/10054/)



##### Low (Medium)

### Description

A cookie has been set without the SameSite attribute, which means that the cookie can be sent as a result of a 'cross-site' request. The SameSite attribute is an effective counter measure to cross-site request forgery, cross-site script inclusion, and timing attacks.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/`
  * Method: `POST`
  * Parameter: `dvwaSession`
  * Attack: ``
  * Evidence: `Set-Cookie: dvwaSession`
  * Other Info: ``


Instances: 1

### Solution

Ensure that the SameSite attribute is set to either 'lax' or ideally 'strict' for all cookies.

### Reference


* [ https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-cookie-same-site ](https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-cookie-same-site)


#### CWE Id: [ 1275 ](https://cwe.mitre.org/data/definitions/1275.html)


#### WASC Id: 13

#### Source ID: 3

### [ In Page Banner Information Leak ](https://www.zaproxy.org/docs/alerts/10009/)



##### Low (High)

### Description

The server returned a version banner string in the response content. Such information leaks may allow attackers to further target specific issues impacting the product and version in use.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/ZAP
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/ZAP`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.68`
  * Other Info: `There is a chance that the highlight in the finding is on a value in the headers, versus the actual matched string in the response body.`


Instances: 1

### Solution

Configure the server to prevent such information leaks. For example:
Under Tomcat this is done via the "server" directive and implementation of custom error pages.
Under Apache this is done via the "ServerSignature" and "ServerTokens" directives.

### Reference


* [ https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/08-Testing_for_Error_Handling/ ](https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/08-Testing_for_Error_Handling/)


#### CWE Id: [ 497 ](https://cwe.mitre.org/data/definitions/497.html)


#### WASC Id: 13

#### Source ID: 3

### [ Private IP Disclosure ](https://www.zaproxy.org/docs/alerts/2/)



##### Low (Medium)

### Description

A private IP (such as 10.x.x.x, 172.x.x.x, 192.168.x.x) or an Amazon EC2 private hostname (for example, ip-10-0-56-78) has been found in the HTTP response body. This information might be helpful for further attacks targeting internal systems.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/fi/%3Fpage=file1.php
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/fi/ (page)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `172.18.0.2`
  * Other Info: `172.18.0.2
`


Instances: 1

### Solution

Remove the private IP address from the HTTP response body. For comments, use JSP/ASP/PHP comment instead of HTML/JavaScript comment which can be seen by client browsers.

### Reference


* [ https://datatracker.ietf.org/doc/html/rfc1918 ](https://datatracker.ietf.org/doc/html/rfc1918)


#### CWE Id: [ 497 ](https://cwe.mitre.org/data/definitions/497.html)


#### WASC Id: 13

#### Source ID: 3

### [ Strict-Transport-Security Header Not Set ](https://www.zaproxy.org/docs/alerts/10035/)



##### Low (High)

### Description

HTTP Strict Transport Security (HSTS) is a web security policy mechanism whereby a web server declares that complying user agents (such as a web browser) are to interact with it using only secure HTTPS connections (i.e. HTTP layered over TLS/SSL). HSTS is an IETF standards track protocol and is specified in RFC 6797.

* URL: https://20.8.94.69/portaal/dvwa/
  * Node Name: `https://20.8.94.69/portaal/dvwa/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/index.php
  * Node Name: `https://20.8.94.69/portaal/dvwa/index.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution

Ensure that your web server, application server, load balancer, etc. is configured to enforce Strict-Transport-Security.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/HTTP_Strict_Transport_Security_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/HTTP_Strict_Transport_Security_Cheat_Sheet.html)
* [ https://owasp.org/www-community/Security_Headers ](https://owasp.org/www-community/Security_Headers)
* [ https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security ](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security)
* [ https://caniuse.com/stricttransportsecurity ](https://caniuse.com/stricttransportsecurity)
* [ https://datatracker.ietf.org/doc/html/rfc6797 ](https://datatracker.ietf.org/doc/html/rfc6797)


#### CWE Id: [ 319 ](https://cwe.mitre.org/data/definitions/319.html)


#### WASC Id: 15

#### Source ID: 3

### [ Timestamp Disclosure - Unix ](https://www.zaproxy.org/docs/alerts/10096/)



##### Low (Low)

### Description

A timestamp was disclosed by the application/web server. - Unix

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1732584193`
  * Other Info: `1732584193, which evaluates to: 2024-11-26 01:23:13.`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1732584194`
  * Other Info: `1732584194, which evaluates to: 2024-11-26 01:23:14.`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1770035416`
  * Other Info: `1770035416, which evaluates to: 2026-02-02 12:30:16.`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1958414417`
  * Other Info: `1958414417, which evaluates to: 2032-01-22 20:00:17.`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1990404162`
  * Other Info: `1990404162, which evaluates to: 2033-01-27 02:02:42.`

Instances: Systemic


### Solution

Manually confirm that the timestamp data is not sensitive, and that the data cannot be aggregated to disclose exploitable patterns.

### Reference


* [ https://cwe.mitre.org/data/definitions/200.html ](https://cwe.mitre.org/data/definitions/200.html)


#### CWE Id: [ 497 ](https://cwe.mitre.org/data/definitions/497.html)


#### WASC Id: 13

#### Source ID: 3

### [ X-Content-Type-Options Header Missing ](https://www.zaproxy.org/docs/alerts/10021/)



##### Low (Medium)

### Description

The Anti-MIME-Sniffing header X-Content-Type-Options was not set to 'nosniff'. This allows older versions of Internet Explorer and Chrome to perform MIME-sniffing on the response body, potentially causing the response body to be interpreted and displayed as a content type other than the declared content type. Current (early 2014) and legacy versions of Firefox will use the declared content type (if one is set), rather than performing MIME-sniffing.

* URL: https://20.8.94.69/portaal/dvwa/
  * Node Name: `https://20.8.94.69/portaal/dvwa/`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`
* URL: https://20.8.94.69/portaal/dvwa/index.php
  * Node Name: `https://20.8.94.69/portaal/dvwa/index.php`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`

Instances: Systemic


### Solution

Ensure that the application/web server sets the Content-Type header appropriately, and that it sets the X-Content-Type-Options header to 'nosniff' for all web pages.
If possible, ensure that the end user uses a standards-compliant and modern web browser that does not perform MIME-sniffing at all, or that can be directed by the web application/web server to not perform MIME-sniffing.

### Reference


* [ https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/compatibility/gg622941(v=vs.85) ](https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/compatibility/gg622941(v=vs.85))
* [ https://owasp.org/www-community/Security_Headers ](https://owasp.org/www-community/Security_Headers)


#### CWE Id: [ 693 ](https://cwe.mitre.org/data/definitions/693.html)


#### WASC Id: 15

#### Source ID: 3

### [ Authentication Request Identified ](https://www.zaproxy.org/docs/alerts/10111/)



##### Informational (High)

### Description

The given request has been identified as an authentication request. The 'Other Info' field contains a set of key=value lines which identify any relevant fields. If the request is in a context which has an Authentication Method set to "Auto-Detect" then this rule will change the authentication to match the request identified.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/%3FLogin=Login&password=ZAP&username=ZAP
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/ (Login,password,username)`
  * Method: `GET`
  * Parameter: `Login`
  * Attack: ``
  * Evidence: `password`
  * Other Info: `userParam=Login
userValue=Login
passwordParam=password
referer=https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/`


Instances: 1

### Solution

This is an informational alert rather than a vulnerability and so there is nothing to fix.

### Reference


* [ https://www.zaproxy.org/docs/desktop/addons/authentication-helper/auth-req-id/ ](https://www.zaproxy.org/docs/desktop/addons/authentication-helper/auth-req-id/)



#### Source ID: 3

### [ GET for POST ](https://www.zaproxy.org/docs/alerts/10058/)



##### Informational (High)

### Description

A request that was originally observed as a POST was also accepted as a GET. This issue does not represent a security weakness unto itself, however, it may facilitate simplification of other attacks. For example if the original POST is subject to Cross-Site Scripting (XSS), then this finding may indicate that a simplified (GET based) XSS may also be possible.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/ (include)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `GET https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/?include=ZAP HTTP/1.1`
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/ (Submit,ip)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `GET https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/?Submit=Submit&ip=ZAP HTTP/1.1`
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/ (phrase,send,token)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `GET https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/?phrase=ChangeMe&send=Submit&token= HTTP/1.1`
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `GET https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/ HTTP/1.1`
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/ (btnClear,mtxMessage,txtName)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `GET https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/?btnClear=Clear%20Guestbook&mtxMessage=&txtName=ZAP HTTP/1.1`
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/ (btnSign,mtxMessage,txtName)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `GET https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/?btnSign=Sign%20Guestbook&mtxMessage=&txtName=ZAP HTTP/1.1`
  * Other Info: ``


Instances: 6

### Solution

Ensure that only POST is accepted where POST is expected.

### Reference



#### CWE Id: [ 16 ](https://cwe.mitre.org/data/definitions/16.html)


#### WASC Id: 20

#### Source ID: 1

### [ Information Disclosure - Sensitive Information in URL ](https://www.zaproxy.org/docs/alerts/10024/)



##### Informational (Medium)

### Description

The request appeared to contain sensitive information leaked in the URL. This can violate PCI and most organizational compliance policies. You can configure the list of strings for this check to add or remove values specific to your environment.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/%3FLogin=Login&password=ZAP&username=ZAP
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/ (Login,password,username)`
  * Method: `GET`
  * Parameter: `password`
  * Attack: ``
  * Evidence: `password`
  * Other Info: `The URL contains potentially sensitive information. The following string was found via the pattern: pass
password`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/%3FLogin=Login&password=ZAP&username=ZAP
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/ (Login,password,username)`
  * Method: `GET`
  * Parameter: `username`
  * Attack: ``
  * Evidence: `username`
  * Other Info: `The URL contains potentially sensitive information. The following string was found via the pattern: user
username`


Instances: 2

### Solution

Do not pass sensitive information in URIs.

### Reference



#### CWE Id: [ 598 ](https://cwe.mitre.org/data/definitions/598.html)


#### WASC Id: 13

#### Source ID: 3

### [ Information Disclosure - Suspicious Comments ](https://www.zaproxy.org/docs/alerts/10027/)



##### Informational (Medium)

### Description

The response appears to contain suspicious comments which may help an attacker.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `/*
MD5 code from here
https://github`
  * Other Info: `The following pattern was used: \bFROM\b and was detected in likely comment: "/*
MD5 code from here
https://github.com/blueimp/JavaScript-MD5
*/", see evidence field for the suspicious comment/snippet.`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/ ()(phrase,send,token)`
  * Method: `POST`
  * Parameter: ``
  * Attack: ``
  * Evidence: `/*
MD5 code from here
https://github`
  * Other Info: `The following pattern was used: \bFROM\b and was detected in likely comment: "/*
MD5 code from here
https://github.com/blueimp/JavaScript-MD5
*/", see evidence field for the suspicious comment/snippet.`


Instances: 2

### Solution

Remove all comments that return information that may help an attacker and fix any underlying problems they refer to.

### Reference



#### CWE Id: [ 615 ](https://cwe.mitre.org/data/definitions/615.html)


#### WASC Id: 13

#### Source ID: 3

### [ Modern Web Application ](https://www.zaproxy.org/docs/alerts/10109/)



##### Informational (Medium)

### Description

The application appears to be a modern web application. If you need to explore it automatically then the Client Spider may well be more effective than the standard one.

* URL: https://20.8.94.69/portaal/dvwa/
  * Node Name: `https://20.8.94.69/portaal/dvwa/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<a href="#" onclick="javascript:toggleTheme();" class="theme-icon" title="Toggle theme between light and dark.">
                    <img src="dvwa/images/theme-light-dark.png" alt="Damn Vulnerable Web Application" />
                </a>`
  * Other Info: `Links have been found that do not have traditional href attributes, which is an indication that this is a modern web application.`
* URL: https://20.8.94.69/portaal/dvwa/index.php
  * Node Name: `https://20.8.94.69/portaal/dvwa/index.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<a href="#" onclick="javascript:toggleTheme();" class="theme-icon" title="Toggle theme between light and dark.">
                    <img src="dvwa/images/theme-light-dark.png" alt="Damn Vulnerable Web Application" />
                </a>`
  * Other Info: `Links have been found that do not have traditional href attributes, which is an indication that this is a modern web application.`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<a href="#" onclick="javascript:toggleTheme();" class="theme-icon" title="Toggle theme between light and dark.">
                    <img src="../../dvwa/images/theme-light-dark.png" alt="Damn Vulnerable Web Application" />
                </a>`
  * Other Info: `Links have been found that do not have traditional href attributes, which is an indication that this is a modern web application.`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<a href="#" onclick="javascript:toggleTheme();" class="theme-icon" title="Toggle theme between light and dark.">
                    <img src="../../dvwa/images/theme-light-dark.png" alt="Damn Vulnerable Web Application" />
                </a>`
  * Other Info: `Links have been found that do not have traditional href attributes, which is an indication that this is a modern web application.`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/fi/%3Fpage=include.php
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/fi/ (page)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<a href="#" onclick="javascript:toggleTheme();" class="theme-icon" title="Toggle theme between light and dark.">
                    <img src="../../dvwa/images/theme-light-dark.png" alt="Damn Vulnerable Web Application" />
                </a>`
  * Other Info: `Links have been found that do not have traditional href attributes, which is an indication that this is a modern web application.`

Instances: Systemic


### Solution

This is an informational alert and so no changes are required.

### Reference




#### Source ID: 3

### [ Re-examine Cache-control Directives ](https://www.zaproxy.org/docs/alerts/10015/)



##### Informational (Low)

### Description

The cache-control header has not been set properly or is missing, allowing the browser and proxies to cache content. For static assets like css, js, or image files this might be intended, however, the resources should be reviewed to ensure that no sensitive content will be cached.

* URL: https://20.8.94.69/portaal/dvwa/
  * Node Name: `https://20.8.94.69/portaal/dvwa/`
  * Method: `GET`
  * Parameter: `cache-control`
  * Attack: ``
  * Evidence: `no-cache, must-revalidate`
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/index.php
  * Node Name: `https://20.8.94.69/portaal/dvwa/index.php`
  * Method: `GET`
  * Parameter: `cache-control`
  * Attack: ``
  * Evidence: `no-cache, must-revalidate`
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/`
  * Method: `GET`
  * Parameter: `cache-control`
  * Attack: ``
  * Evidence: `no-cache, must-revalidate`
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/`
  * Method: `GET`
  * Parameter: `cache-control`
  * Attack: ``
  * Evidence: `no-cache, must-revalidate`
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/weak_id/`
  * Method: `GET`
  * Parameter: `cache-control`
  * Attack: ``
  * Evidence: `no-cache, must-revalidate`
  * Other Info: ``

Instances: Systemic


### Solution

For secure content, ensure the cache-control HTTP header is set with "no-cache, no-store, must-revalidate". If an asset should be cached consider setting the directives "public, max-age, immutable".

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html#web-content-caching ](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html#web-content-caching)
* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cache-Control ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cache-Control)
* [ https://grayduck.mn/2021/09/13/cache-control-recommendations/ ](https://grayduck.mn/2021/09/13/cache-control-recommendations/)


#### CWE Id: [ 525 ](https://cwe.mitre.org/data/definitions/525.html)


#### WASC Id: 13

#### Source ID: 3

### [ User Agent Fuzzer ](https://www.zaproxy.org/docs/alerts/10104/)



##### Informational (Medium)

### Description

Check for differences in response based on fuzzed User Agent (eg. mobile sites, access as a Search Engine Crawler). Compares the response statuscode and the hashcode of the response body with the original response.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/`
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)`
  * Evidence: ``
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/`
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)`
  * Evidence: ``
  * Other Info: ``
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/`
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)`
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution



### Reference


* [ https://owasp.org/www-project-web-security-testing-guide/ ](https://owasp.org/www-project-web-security-testing-guide/)



#### Source ID: 1

### [ User Controllable HTML Element Attribute (Potential XSS) ](https://www.zaproxy.org/docs/alerts/10031/)



##### Informational (Low)

### Description

This check looks at user-supplied input in query string parameters and POST data to identify where certain HTML attribute values might be controlled. This provides hot-spot detection for XSS (cross-site scripting) that will require further review by a security analyst to determine exploitability.

* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/%3FLogin=Login&password=ZAP&username=ZAP
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/ (Login,password,username)`
  * Method: `GET`
  * Parameter: `Login`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://20.8.94.69/portaal/dvwa/vulnerabilities/brute/?Login=Login&password=ZAP&username=ZAP

appears to include user input in:
a(n) [input] tag [value] attribute

The user input found was:
Login=Login

The user-controlled value was:
login`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/sqli/%3FSubmit=Submit&id=ZAP
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/sqli/ (Submit,id)`
  * Method: `GET`
  * Parameter: `Submit`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://20.8.94.69/portaal/dvwa/vulnerabilities/sqli/?Submit=Submit&id=ZAP

appears to include user input in:
a(n) [input] tag [type] attribute

The user input found was:
Submit=Submit

The user-controlled value was:
submit`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/ ()(include)`
  * Method: `POST`
  * Parameter: `include`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://20.8.94.69/portaal/dvwa/vulnerabilities/csp/

appears to include user input in:
a(n) [script] tag [src] attribute

The user input found was:
include=ZAP

The user-controlled value was:
zap`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/ ()(Submit,ip)`
  * Method: `POST`
  * Parameter: `Submit`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://20.8.94.69/portaal/dvwa/vulnerabilities/exec/

appears to include user input in:
a(n) [input] tag [type] attribute

The user input found was:
Submit=Submit

The user-controlled value was:
submit`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/ ()(phrase,send,token)`
  * Method: `POST`
  * Parameter: `phrase`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/

appears to include user input in:
a(n) [input] tag [value] attribute

The user input found was:
phrase=ChangeMe

The user-controlled value was:
changeme`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/ ()(phrase,send,token)`
  * Method: `POST`
  * Parameter: `send`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://20.8.94.69/portaal/dvwa/vulnerabilities/javascript/

appears to include user input in:
a(n) [input] tag [type] attribute

The user input found was:
send=Submit

The user-controlled value was:
submit`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/ ()(btnClear,mtxMessage,txtName)`
  * Method: `POST`
  * Parameter: `btnClear`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/

appears to include user input in:
a(n) [input] tag [value] attribute

The user input found was:
btnClear=Clear Guestbook

The user-controlled value was:
clear guestbook`
* URL: https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/ ()(btnSign,mtxMessage,txtName)`
  * Method: `POST`
  * Parameter: `btnSign`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://20.8.94.69/portaal/dvwa/vulnerabilities/xss_s/

appears to include user input in:
a(n) [input] tag [value] attribute

The user input found was:
btnSign=Sign Guestbook

The user-controlled value was:
sign guestbook`


Instances: 8

### Solution

Validate all input and sanitize output it before writing to any HTML attributes.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)


#### CWE Id: [ 20 ](https://cwe.mitre.org/data/definitions/20.html)


#### WASC Id: 20

#### Source ID: 3


