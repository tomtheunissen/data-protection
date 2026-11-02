# ZAP by Checkmarx Scanning Report

ZAP by [Checkmarx](https://checkmarx.com/).


## Summary of Alerts

| Risk Level | Number of Alerts |
| --- | --- |
| High | 9 |
| Medium | 7 |
| Low | 10 |
| Informational | 6 |




## Insights

| Level | Reason | Site | Description | Statistic |
| --- | --- | --- | --- | --- |
| Low | Warning |  | ZAP errors logged - see the zap.log file for details | 1    |
| Low | Warning |  | ZAP warnings logged - see the zap.log file for details | 24    |
| Info | Informational |  | Percentage of network failures | 1 % |
| Info | Informational | https://192.168.4.4 | Percentage of responses with status code 2xx | 69 % |
| Info | Informational | https://192.168.4.4 | Percentage of responses with status code 3xx | 2 % |
| Info | Informational | https://192.168.4.4 | Percentage of responses with status code 4xx | 27 % |
| Info | Informational | https://192.168.4.4 | Percentage of endpoints with content type application/pdf | 1 % |
| Info | Informational | https://192.168.4.4 | Percentage of endpoints with content type application/vnd.apple.installer+xml | 1 % |
| Info | Informational | https://192.168.4.4 | Percentage of endpoints with content type image/png | 6 % |
| Info | Informational | https://192.168.4.4 | Percentage of endpoints with content type image/vnd.microsoft.icon | 1 % |
| Info | Informational | https://192.168.4.4 | Percentage of endpoints with content type text/css | 1 % |
| Info | Informational | https://192.168.4.4 | Percentage of endpoints with content type text/html | 60 % |
| Info | Informational | https://192.168.4.4 | Percentage of endpoints with content type text/javascript | 4 % |
| Info | Informational | https://192.168.4.4 | Percentage of endpoints with content type text/markdown | 21 % |
| Info | Informational | https://192.168.4.4 | Percentage of endpoints with method GET | 89 % |
| Info | Informational | https://192.168.4.4 | Percentage of endpoints with method POST | 10 % |
| Info | Informational | https://192.168.4.4 | Count of total endpoints | 64    |
| Info | Informational | https://192.168.4.4 | Percentage of slow responses | 2 % |







## Alerts

| Name | Risk Level | Number of Instances |
| --- | --- | --- |
| Cross Site Scripting (Reflected) | High | 4 |
| External Redirect | High | 1 |
| PHP Version with Known Vulnerabilities | High | 1 |
| Path Traversal | High | 1 |
| Remote File Inclusion | High | 1 |
| Remote OS Command Injection | High | 1 |
| Remote OS Command Injection (Time Based) | High | 3 |
| SQL Injection | High | 2 |
| SQL Injection - MySQL | High | 2 |
| Absence of Anti-CSRF Tokens | Medium | Systemic |
| Application Error Disclosure | Medium | 16 |
| CSP: Failure to Define Directive with No Fallback | Medium | 2 |
| CSP: Wildcard Directive | Medium | 2 |
| CSP: style-src unsafe-inline | Medium | 2 |
| Content Security Policy (CSP) Header Not Set | Medium | Systemic |
| Missing Anti-clickjacking Header | Medium | Systemic |
| Cookie No HttpOnly Flag | Low | 1 |
| Cookie Without Secure Flag | Low | 1 |
| Cookie without SameSite Attribute | Low | 1 |
| In Page Banner Information Leak | Low | 3 |
| Information Disclosure - Debug Error Messages | Low | 16 |
| Private IP Disclosure | Low | 2 |
| Server Leaks Information via "X-Powered-By" HTTP Response Header Field(s) | Low | Systemic |
| Strict-Transport-Security Header Not Set | Low | Systemic |
| Timestamp Disclosure - Unix | Low | Systemic |
| X-Content-Type-Options Header Missing | Low | Systemic |
| Authentication Request Identified | Informational | 1 |
| Information Disclosure - Sensitive Information in URL | Informational | 2 |
| Information Disclosure - Suspicious Comments | Informational | 2 |
| Modern Web Application | Informational | Systemic |
| Re-examine Cache-control Directives | Informational | Systemic |
| User Controllable HTML Element Attribute (Potential XSS) | Informational | 11 |




## Alert Detail



### [ Cross Site Scripting (Reflected) ](https://www.zaproxy.org/docs/alerts/40012/)



##### High (Medium)

### Description

Cross-site Scripting (XSS) is an attack technique that involves echoing attacker-supplied code into a user's browser instance. A browser instance can be a standard web browser client, or a browser object embedded in a software product such as the browser within WinAmp, an RSS reader, or an email client. The code itself is usually written in HTML/JavaScript, but may also extend to VBScript, ActiveX, Java, Flash, or any other browser-supported technology.
When an attacker gets a user's browser to execute his/her code, the code will run within the security context (or zone) of the hosting web site. With this level of privilege, the code has the ability to read, modify and transmit any sensitive data accessible by the browser. A Cross-site Scripted user could have his/her account hijacked (cookie theft), their browser redirected to another location, or possibly shown fraudulent content delivered by the web site they are visiting. Cross-site Scripting attacks essentially compromise the trust relationship between a user and the web site. Applications utilizing browser object instances which load content from the file system may execute code under the local machine zone allowing for system compromise.

There are three types of Cross-site Scripting attacks: non-persistent, persistent and DOM-based.
Non-persistent attacks and DOM-based attacks require a user to either visit a specially crafted link laced with malicious code, or visit a malicious web page containing a web form, which when posted to the vulnerable site, will mount the attack. Using a malicious form will oftentimes take place when the vulnerable resource only accepts HTTP POST requests. In such a case, the form can be submitted automatically, without the victim's knowledge (e.g. by using JavaScript). Upon clicking on the malicious link or submitting the malicious form, the XSS payload will get echoed back and will get interpreted by the user's browser and execute. Another technique to send almost arbitrary requests (GET and POST) is by using an embedded client, such as Adobe Flash.
Persistent attacks occur when the malicious code is submitted to a web site where it's stored for a period of time. Examples of an attacker's favorite targets often include message board posts, web mail messages, and web chat software. The unsuspecting user is not required to interact with any additional site/link (e.g. an attacker site or a malicious link sent via email), just simply view the web page containing the code.

* URL: https://192.168.4.4/dvwa/vulnerabilities/xss_r/%3Fname=%253C%252Fpre%253E%253CscrIpt%253Ealert%25281%2529%253B%253C%252FscRipt%253E%253Cpre%253E
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/xss_r/ (name)`
  * Method: `GET`
  * Parameter: `name`
  * Attack: `</pre><scrIpt>alert(1);</scRipt><pre>`
  * Evidence: `</pre><scrIpt>alert(1);</scRipt><pre>`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/csp/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/csp/ ()(include)`
  * Method: `POST`
  * Parameter: `include`
  * Attack: `javascript:alert(1);`
  * Evidence: `javascript:alert(1);`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/xss_s/ ()(btnSign,mtxMessage,txtName)`
  * Method: `POST`
  * Parameter: `mtxMessage`
  * Attack: `</div><scrIpt>alert(1);</scRipt><div>`
  * Evidence: `</div><scrIpt>alert(1);</scRipt><div>`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/xss_s/ ()(btnSign,mtxMessage,txtName)`
  * Method: `POST`
  * Parameter: `txtName`
  * Attack: `</div><scrIpt>alert(1);</scRipt><div>`
  * Evidence: `</div><scrIpt>alert(1);</scRipt><div>`
  * Other Info: ``


Instances: 4

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

* URL: https://192.168.4.4/dvwa/vulnerabilities/open_redirect/source/low.php%3Fredirect=https%253A%252F%252F7547773496945034563.owasp.org
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/open_redirect/source/low.php (redirect)`
  * Method: `GET`
  * Parameter: `redirect`
  * Attack: `https://7547773496945034563.owasp.org`
  * Evidence: `https://7547773496945034563.owasp.org`
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

### [ PHP Version with Known Vulnerabilities ](https://www.zaproxy.org/docs/alerts/20020/)



##### High (Medium)

### Description

The server disclosed the version of a server side technology it is running via an HTTP response header, and that version is affected by known vulnerabilities. The version, header and vulnerabilities, listed by severity, are given in the other info. See the references for the details of each.
Note that some distributions backport security fixes without changing the version number, so check whether the fixes have actually been applied before reporting these as confirmed.

* URL: https://192.168.4.4/dvwa/
  * Node Name: `https://192.168.4.4/dvwa/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `PHP/8.5.11`
  * Other Info: `The server disclosed that it is running PHP version 8.5.11 via the "X-Powered-By" HTTP response header.

2 known vulnerabilities: 2 critical, 0 high, 0 medium, 0 low.

Critical: CVE-2026-109618, CVE-2026-109619`


Instances: 1

### Solution

Upgrade PHP to a supported version which includes fixes for the listed vulnerabilities. Also configure the server not to disclose the PHP version, e.g. by setting "expose_php = Off" in php.ini and suppressing version details in the "Server" header.

### Reference


* [ https://www.php.net/supported-versions.php ](https://www.php.net/supported-versions.php)
* [ https://github.com/php/php-src/security/advisories ](https://github.com/php/php-src/security/advisories)
* [ https://www.zaproxy.org/docs/desktop/addons/passive-scan-rules/php-known-vulnerabilities/#cve-2026-109618 ](https://www.zaproxy.org/docs/desktop/addons/passive-scan-rules/php-known-vulnerabilities/#cve-2026-109618)
* [ https://www.zaproxy.org/docs/desktop/addons/passive-scan-rules/php-known-vulnerabilities/#cve-2026-109619 ](https://www.zaproxy.org/docs/desktop/addons/passive-scan-rules/php-known-vulnerabilities/#cve-2026-109619)


#### CWE Id: [ 1395 ](https://cwe.mitre.org/data/definitions/1395.html)


#### WASC Id: 13

#### Source ID: 3

### [ Path Traversal ](https://www.zaproxy.org/docs/alerts/6/)



##### High (Medium)

### Description

The Path Traversal attack technique allows an attacker access to files, directories, and commands that potentially reside outside the web document root directory. An attacker may manipulate a URL in such a way that the web site will execute or reveal the contents of arbitrary files anywhere on the web server. Any device that exposes an HTTP-based interface is potentially vulnerable to Path Traversal.

Most web sites restrict user access to a specific portion of the file-system, typically called the "web document root" or "CGI root" directory. These directories contain the files intended for user access and the executable necessary to drive web application functionality. To access files or execute commands anywhere on the file-system, Path Traversal attacks will utilize the ability of special-characters sequences.

The most basic Path Traversal attack uses the "../" special-character sequence to alter the resource location requested in the URL. Although most popular web servers will prevent this technique from escaping the web document root, alternate encodings of the "../" sequence may help bypass the security filters. These method variations include valid and invalid Unicode-encoding ("..%u2216" or "..%c0%af") of the forward slash character, backslash characters ("..\") on Windows-based servers, URL encoded characters "%2e%2e%2f"), and double URL encoding ("..%255c") of the backslash character.

Even if the web server properly restricts Path Traversal attempts in the URL path, a web application itself may still be vulnerable due to improper handling of user-supplied input. This is a common problem of web applications that use template mechanisms or load static text from files. In variations of the attack, the original URL parameter value is substituted with the file name of one of the web application's dynamic scripts. Consequently, the results can reveal source code because the file is interpreted as text instead of an executable script. These techniques often employ additional special characters such as the dot (".") to reveal the listing of the current working directory, or "%00" NULL characters in order to bypass rudimentary file extension checks.

* URL: https://192.168.4.4/dvwa/vulnerabilities/fi/%3Fpage=%252Fetc%252Fpasswd
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/fi/ (page)`
  * Method: `GET`
  * Parameter: `page`
  * Attack: `/etc/passwd`
  * Evidence: `root:x:0:0`
  * Other Info: ``


Instances: 1

### Solution

Assume all input is malicious. Use an "accept known good" input validation strategy, i.e., use an allow list of acceptable inputs that strictly conform to specifications. Reject any input that does not strictly conform to specifications, or transform it into something that does. Do not rely exclusively on looking for malicious or malformed inputs (i.e., do not rely on a deny list). However, deny lists can be useful for detecting potential attacks or determining which inputs are so malformed that they should be rejected outright.

When performing input validation, consider all potentially relevant properties, including length, type of input, the full range of acceptable values, missing or extra inputs, syntax, consistency across related fields, and conformance to business rules. As an example of business rule logic, "boat" may be syntactically valid because it only contains alphanumeric characters, but it is not valid if you are expecting colors such as "red" or "blue."

For filenames, use stringent allow lists that limit the character set to be used. If feasible, only allow a single "." character in the filename to avoid weaknesses, and exclude directory separators such as "/". Use an allow list of allowable file extensions.

Warning: if you attempt to cleanse your data, then do so that the end result is not in the form that can be dangerous. A sanitizing mechanism can remove characters such as '.' and ';' which may be required for some exploits. An attacker can try to fool the sanitizing mechanism into "cleaning" data into a dangerous form. Suppose the attacker injects a '.' inside a filename (e.g. "sensi.tiveFile") and the sanitizing mechanism removes the character resulting in the valid filename, "sensitiveFile". If the input data are now assumed to be safe, then the file may be compromised. 

Inputs should be decoded and canonicalized to the application's current internal representation before being validated. Make sure that your application does not decode the same input twice. Such errors could be used to bypass allow list schemes by introducing dangerous inputs after they have been checked.

Use a built-in path canonicalization function (such as realpath() in C) that produces the canonical version of the pathname, which effectively removes ".." sequences and symbolic links.

Run your code using the lowest privileges that are required to accomplish the necessary tasks. If possible, create isolated accounts with limited privileges that are only used for a single task. That way, a successful attack will not immediately give the attacker access to the rest of the software or its environment. For example, database applications rarely need to run as the database administrator, especially in day-to-day operations.

When the set of acceptable objects, such as filenames or URLs, is limited or known, create a mapping from a set of fixed input values (such as numeric IDs) to the actual filenames or URLs, and reject all other inputs.

Run your code in a "jail" or similar sandbox environment that enforces strict boundaries between the process and the operating system. This may effectively restrict which files can be accessed in a particular directory or which commands can be executed by your software.

OS-level examples include the Unix chroot jail, AppArmor, and SELinux. In general, managed code may provide some protection. For example, java.io.FilePermission in the Java SecurityManager allows you to specify restrictions on file operations.

This may not be a feasible solution, and it only limits the impact to the operating system; the rest of your application may still be subject to compromise.


### Reference


* [ https://owasp.org/www-community/attacks/Path_Traversal ](https://owasp.org/www-community/attacks/Path_Traversal)
* [ https://cwe.mitre.org/data/definitions/22.html ](https://cwe.mitre.org/data/definitions/22.html)


#### CWE Id: [ 22 ](https://cwe.mitre.org/data/definitions/22.html)


#### WASC Id: 33

#### Source ID: 1

### [ Remote File Inclusion ](https://www.zaproxy.org/docs/alerts/7/)



##### High (Medium)

### Description

Remote File Include (RFI) is an attack technique used to exploit "dynamic file include" mechanisms in web applications. When web applications take user input (URL, parameter value, etc.) and pass them into file include commands, the web application might be tricked into including remote files with malicious code.

Almost all web application frameworks support file inclusion. File inclusion is mainly used for packaging common code into separate files that are later referenced by main application modules. When a web application references an include file, the code in this file may be executed implicitly or explicitly by calling specific procedures. If the choice of module to load is based on elements from the HTTP request, the web application might be vulnerable to RFI.
An attacker can use RFI for:
    * Running malicious code on the server: any code in the included malicious files will be run by the server. If the file include is not executed using some wrapper, code in include files is executed in the context of the server user. This could lead to a complete system compromise.
    * Running malicious code on clients: the attacker's malicious code can manipulate the content of the response sent to the client. The attacker can embed malicious code in the response that will be run by the client (for example, JavaScript to steal the client session cookies).

PHP is particularly vulnerable to RFI attacks due to the extensive use of "file includes" in PHP programming and due to default server configurations that increase susceptibility to an RFI attack.

* URL: https://192.168.4.4/dvwa/vulnerabilities/fi/%3Fpage=http%253A%252F%252Fwww.google.com%252F
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/fi/ (page)`
  * Method: `GET`
  * Parameter: `page`
  * Attack: `http://www.google.com/`
  * Evidence: `<title>Google</title>`
  * Other Info: ``


Instances: 1

### Solution

Phase: Architecture and Design
When the set of acceptable objects, such as filenames or URLs, is limited or known, create a mapping from a set of fixed input values (such as numeric IDs) to the actual filenames or URLs, and reject all other inputs.
For example, ID 1 could map to "inbox.txt" and ID 2 could map to "profile.txt". Features such as the ESAPI AccessReferenceMap provide this capability.

Phases: Architecture and Design; Operation
Run your code in a "jail" or similar sandbox environment that enforces strict boundaries between the process and the operating system. This may effectively restrict which files can be accessed in a particular directory or which commands can be executed by your software.
OS-level examples include the Unix chroot jail, AppArmor, and SELinux. In general, managed code may provide some protection. For example, java.io.FilePermission in the Java SecurityManager allows you to specify restrictions on file operations.
This may not be a feasible solution, and it only limits the impact to the operating system; the rest of your application may still be subject to compromise.
Be careful to avoid CWE-243 and other weaknesses related to jails.
For PHP, the interpreter offers restrictions such as open basedir or safe mode which can make it more difficult for an attacker to escape out of the application. Also consider Suhosin, a hardened PHP extension, which includes various options that disable some of the more dangerous PHP features.

Phase: Implementation
Assume all input is malicious. Use an "accept known good" input validation strategy, i.e., use an allow list of acceptable inputs that strictly conform to specifications. Reject any input that does not strictly conform to specifications, or transform it into something that does. Do not rely exclusively on looking for malicious or malformed inputs (i.e., do not rely on a deny list). However, deny lists can be useful for detecting potential attacks or determining which inputs are so malformed that they should be rejected outright.
When performing input validation, consider all potentially relevant properties, including length, type of input, the full range of acceptable values, missing or extra inputs, syntax, consistency across related fields, and conformance to business rules. As an example of business rule logic, "boat" may be syntactically valid because it only contains alphanumeric characters, but it is not valid if you are expecting colors such as "red" or "blue."
For filenames, use stringent allow lists that limit the character set to be used. If feasible, only allow a single "." character in the filename to avoid weaknesses such as CWE-23, and exclude directory separators such as "/" to avoid CWE-36. Use an allow list of allowable file extensions, which will help to avoid CWE-434.

Phases: Architecture and Design; Operation
Store library, include, and utility files outside of the web document root, if possible. Otherwise, store them in a separate directory and use the web server's access control capabilities to prevent attackers from directly requesting them. One common practice is to define a fixed constant in each calling program, then check for the existence of the constant in the library/include file; if the constant does not exist, then the file was directly requested, and it can exit immediately.
This significantly reduces the chance of an attacker being able to bypass any protection mechanisms that are in the base program but not in the include files. It will also reduce your attack surface.

Phases: Architecture and Design; Implementation
Understand all the potential areas where untrusted inputs can enter your software: parameters or arguments, cookies, anything read from the network, environment variables, reverse DNS lookups, query results, request headers, URL components, e-mail, files, databases, and any external systems that provide data to the application. Remember that such inputs may be obtained indirectly through API calls.
Many file inclusion problems occur because the programmer assumed that certain inputs could not be modified, especially for cookies and URL components.

### Reference


* [ https://owasp.org/www-project-web-security-testing-guide/v42/4-Web_Application_Security_Testing/07-Input_Validation_Testing/11.2-Testing_for_Remote_File_Inclusion ](https://owasp.org/www-project-web-security-testing-guide/v42/4-Web_Application_Security_Testing/07-Input_Validation_Testing/11.2-Testing_for_Remote_File_Inclusion)
* [ https://cwe.mitre.org/data/definitions/98.html ](https://cwe.mitre.org/data/definitions/98.html)


#### CWE Id: [ 98 ](https://cwe.mitre.org/data/definitions/98.html)


#### WASC Id: 5

#### Source ID: 1

### [ Remote OS Command Injection ](https://www.zaproxy.org/docs/alerts/90020/)



##### High (Medium)

### Description

Attack technique used for unauthorized execution of operating system commands. This attack is possible when an application accepts untrusted input to build operating system commands in an insecure manner involving improper data sanitization, and/or improper calling of external programs.

* URL: https://192.168.4.4/dvwa/vulnerabilities/exec/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/exec/ ()(Submit,ip)`
  * Method: `POST`
  * Parameter: `ip`
  * Attack: `ZAP&cat /etc/passwd&`
  * Evidence: `root:x:0:0`
  * Other Info: `The scan rule was able to retrieve the content of a file or command by sending [ZAP&cat /etc/passwd&] to the operating system running this application.`


Instances: 1

### Solution

If at all possible, use library calls rather than external processes to recreate the desired functionality.

Run your code in a "jail" or similar sandbox environment that enforces strict boundaries between the process and the operating system. This may effectively restrict which files can be accessed in a particular directory or which commands can be executed by your software.

OS-level examples include the Unix chroot jail, AppArmor, and SELinux. In general, managed code may provide some protection. For example, java.io.FilePermission in the Java SecurityManager allows you to specify restrictions on file operations.
This may not be a feasible solution, and it only limits the impact to the operating system; the rest of your application may still be subject to compromise.

For any data that will be used to generate a command to be executed, keep as much of that data out of external control as possible. For example, in web applications, this may require storing the command locally in the session's state instead of sending it out to the client in a hidden form field.

Use a vetted library or framework that does not allow this weakness to occur or provides constructs that make this weakness easier to avoid.

For example, consider using the ESAPI Encoding control or a similar tool, library, or framework. These will help the programmer encode outputs in a manner less prone to error.

If you need to use dynamically-generated query strings or commands in spite of the risk, properly quote arguments and escape any special characters within those arguments. The most conservative approach is to escape or filter all characters that do not pass an extremely strict allow list (such as everything that is not alphanumeric or white space). If some special characters are still needed, such as white space, wrap each argument in quotes after the escaping/filtering step. Be careful of argument injection.

If the program to be executed allows arguments to be specified within an input file or from standard input, then consider using that mode to pass arguments instead of the command line.

If available, use structured mechanisms that automatically enforce the separation between data and code. These mechanisms may be able to provide the relevant quoting, encoding, and validation automatically, instead of relying on the developer to provide this capability at every point where output is generated.

Some languages offer multiple functions that can be used to invoke commands. Where possible, identify any function that invokes a command shell using a single string, and replace it with a function that requires individual arguments. These functions typically perform appropriate quoting and filtering of arguments. For example, in C, the system() function accepts a string that contains the entire command to be executed, whereas execl(), execve(), and others require an array of strings, one for each argument. In Windows, CreateProcess() only accepts one command at a time. In Perl, if system() is provided with an array of arguments, then it will quote each of the arguments.

Assume all input is malicious. Use an "accept known good" input validation strategy, i.e., use an allow list of acceptable inputs that strictly conform to specifications. Reject any input that does not strictly conform to specifications, or transform it into something that does. Do not rely exclusively on looking for malicious or malformed inputs (i.e., do not rely on a deny list). However, deny lists can be useful for detecting potential attacks or determining which inputs are so malformed that they should be rejected outright.

When performing input validation, consider all potentially relevant properties, including length, type of input, the full range of acceptable values, missing or extra inputs, syntax, consistency across related fields, and conformance to business rules. As an example of business rule logic, "boat" may be syntactically valid because it only contains alphanumeric characters, but it is not valid if you are expecting colors such as "red" or "blue."

When constructing OS command strings, use stringent allow lists that limit the character set based on the expected value of the parameter in the request. This will indirectly limit the scope of an attack, but this technique is less important than proper output encoding and escaping.

Note that proper output encoding, escaping, and quoting is the most effective solution for preventing OS command injection, although input validation may provide some defense-in-depth. This is because it effectively limits what will appear in output. Input validation will not always prevent OS command injection, especially if you are required to support free-form text fields that could contain arbitrary characters. For example, when invoking a mail program, you might need to allow the subject field to contain otherwise-dangerous inputs like ";" and ">" characters, which would need to be escaped or otherwise handled. In this case, stripping the character might reduce the risk of OS command injection, but it would produce incorrect behavior because the subject field would not be recorded as the user intended. This might seem to be a minor inconvenience, but it could be more important when the program relies on well-structured subject lines in order to pass messages to other components.

Even if you make a mistake in your validation (such as forgetting one out of 100 input fields), appropriate encoding is still likely to protect you from injection-based attacks. As long as it is not done in isolation, input validation is still a useful technique, since it may significantly reduce your attack surface, allow you to detect some attacks, and provide other security benefits that proper encoding does not address.

### Reference


* [ https://cwe.mitre.org/data/definitions/78.html ](https://cwe.mitre.org/data/definitions/78.html)
* [ https://owasp.org/www-community/attacks/Command_Injection ](https://owasp.org/www-community/attacks/Command_Injection)


#### CWE Id: [ 78 ](https://cwe.mitre.org/data/definitions/78.html)


#### WASC Id: 31

#### Source ID: 1

### [ Remote OS Command Injection (Time Based) ](https://www.zaproxy.org/docs/alerts/90037/)



##### High (Medium)

### Description

Attack technique used for unauthorized execution of operating system commands. This attack is possible when an application accepts untrusted input to build operating system commands in an insecure manner involving improper data sanitization, and/or improper calling of external programs.

* URL: https://192.168.4.4/dvwa/vulnerabilities/csp/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/csp/ ()(include)`
  * Method: `POST`
  * Parameter: `include`
  * Attack: `ZAP&sleep 15&`
  * Evidence: ``
  * Other Info: `The scan rule was able to control the timing of the application response by sending [ZAP&sleep 15&] to the operating system running this application.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/exec/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/exec/ ()(Submit,ip)`
  * Method: `POST`
  * Parameter: `ip`
  * Attack: `ZAP&sleep 15&`
  * Evidence: ``
  * Other Info: `The scan rule was able to control the timing of the application response by sending [ZAP&sleep 15&] to the operating system running this application.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/upload/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/upload/ ()(MAX_FILE_SIZE,Upload,uploaded)`
  * Method: `POST`
  * Parameter: `MAX_FILE_SIZE`
  * Attack: `100000&sleep 15&`
  * Evidence: ``
  * Other Info: `The scan rule was able to control the timing of the application response by sending [100000&sleep 15&] to the operating system running this application.`


Instances: 3

### Solution

If at all possible, use library calls rather than external processes to recreate the desired functionality.

Run your code in a "jail" or similar sandbox environment that enforces strict boundaries between the process and the operating system. This may effectively restrict which files can be accessed in a particular directory or which commands can be executed by your software.

OS-level examples include the Unix chroot jail, AppArmor, and SELinux. In general, managed code may provide some protection. For example, java.io.FilePermission in the Java SecurityManager allows you to specify restrictions on file operations.
This may not be a feasible solution, and it only limits the impact to the operating system; the rest of your application may still be subject to compromise.

For any data that will be used to generate a command to be executed, keep as much of that data out of external control as possible. For example, in web applications, this may require storing the command locally in the session's state instead of sending it out to the client in a hidden form field.

Use a vetted library or framework that does not allow this weakness to occur or provides constructs that make this weakness easier to avoid.

For example, consider using the ESAPI Encoding control or a similar tool, library, or framework. These will help the programmer encode outputs in a manner less prone to error.

If you need to use dynamically-generated query strings or commands in spite of the risk, properly quote arguments and escape any special characters within those arguments. The most conservative approach is to escape or filter all characters that do not pass an extremely strict allow list (such as everything that is not alphanumeric or white space). If some special characters are still needed, such as white space, wrap each argument in quotes after the escaping/filtering step. Be careful of argument injection.

If the program to be executed allows arguments to be specified within an input file or from standard input, then consider using that mode to pass arguments instead of the command line.

If available, use structured mechanisms that automatically enforce the separation between data and code. These mechanisms may be able to provide the relevant quoting, encoding, and validation automatically, instead of relying on the developer to provide this capability at every point where output is generated.

Some languages offer multiple functions that can be used to invoke commands. Where possible, identify any function that invokes a command shell using a single string, and replace it with a function that requires individual arguments. These functions typically perform appropriate quoting and filtering of arguments. For example, in C, the system() function accepts a string that contains the entire command to be executed, whereas execl(), execve(), and others require an array of strings, one for each argument. In Windows, CreateProcess() only accepts one command at a time. In Perl, if system() is provided with an array of arguments, then it will quote each of the arguments.

Assume all input is malicious. Use an "accept known good" input validation strategy, i.e., use an allow list of acceptable inputs that strictly conform to specifications. Reject any input that does not strictly conform to specifications, or transform it into something that does. Do not rely exclusively on looking for malicious or malformed inputs (i.e., do not rely on a deny list). However, deny lists can be useful for detecting potential attacks or determining which inputs are so malformed that they should be rejected outright.

When performing input validation, consider all potentially relevant properties, including length, type of input, the full range of acceptable values, missing or extra inputs, syntax, consistency across related fields, and conformance to business rules. As an example of business rule logic, "boat" may be syntactically valid because it only contains alphanumeric characters, but it is not valid if you are expecting colors such as "red" or "blue."

When constructing OS command strings, use stringent allow lists that limit the character set based on the expected value of the parameter in the request. This will indirectly limit the scope of an attack, but this technique is less important than proper output encoding and escaping.

Note that proper output encoding, escaping, and quoting is the most effective solution for preventing OS command injection, although input validation may provide some defense-in-depth. This is because it effectively limits what will appear in output. Input validation will not always prevent OS command injection, especially if you are required to support free-form text fields that could contain arbitrary characters. For example, when invoking a mail program, you might need to allow the subject field to contain otherwise-dangerous inputs like ";" and ">" characters, which would need to be escaped or otherwise handled. In this case, stripping the character might reduce the risk of OS command injection, but it would produce incorrect behavior because the subject field would not be recorded as the user intended. This might seem to be a minor inconvenience, but it could be more important when the program relies on well-structured subject lines in order to pass messages to other components.

Even if you make a mistake in your validation (such as forgetting one out of 100 input fields), appropriate encoding is still likely to protect you from injection-based attacks. As long as it is not done in isolation, input validation is still a useful technique, since it may significantly reduce your attack surface, allow you to detect some attacks, and provide other security benefits that proper encoding does not address.

### Reference


* [ https://cwe.mitre.org/data/definitions/78.html ](https://cwe.mitre.org/data/definitions/78.html)
* [ https://owasp.org/www-community/attacks/Command_Injection ](https://owasp.org/www-community/attacks/Command_Injection)


#### CWE Id: [ 78 ](https://cwe.mitre.org/data/definitions/78.html)


#### WASC Id: 31

#### Source ID: 1

### [ SQL Injection ](https://www.zaproxy.org/docs/alerts/40018/)



##### High (Medium)

### Description

SQL injection may be possible.

* URL: https://192.168.4.4/dvwa/vulnerabilities/sqli_blind/%3FSubmit=Submit&id=ZAP%2527+AND+%25271%2527%253D%25271%2527+--+
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/sqli_blind/ (Submit,id)`
  * Method: `GET`
  * Parameter: `id`
  * Attack: `ZAP' OR '1'='1' -- `
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [ZAP' AND '1'='1' -- ] and [ZAP' OR '1'='1' -- ]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was NOT returned for the original parameter.
The vulnerability was detected by successfully retrieving more data than originally returned, by manipulating the parameter.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/xss_s/ ()(btnSign,mtxMessage,txtName)`
  * Method: `POST`
  * Parameter: `mtxMessage`
  * Attack: `' OR '1'='1`
  * Evidence: ``
  * Other Info: `The page results were successfully manipulated using the boolean conditions [' AND '1'='1] and [' OR '1'='1]
The parameter value being modified was stripped from the HTML output for the purposes of the comparison.
Data was NOT returned for the original parameter.
The vulnerability was detected by successfully retrieving more data than originally returned, by manipulating the parameter.`


Instances: 2

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

### [ SQL Injection - MySQL ](https://www.zaproxy.org/docs/alerts/40018/)



##### High (Medium)

### Description

SQL injection may be possible.

* URL: https://192.168.4.4/dvwa/vulnerabilities/brute/%3FLogin=Login&password=ZAP&username=%2527
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/brute/ (Login,password,username)`
  * Method: `GET`
  * Parameter: `username`
  * Attack: `'`
  * Evidence: `You have an error in your SQL syntax`
  * Other Info: `RDBMS [MySQL] likely, given error message regular expression [\QYou have an error in your SQL syntax\E] matched by the HTML results.
The vulnerability was detected by manipulating the parameter to cause a database error message to be returned and recognised.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/sqli/%3FSubmit=Submit&id=%2527
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/sqli/ (Submit,id)`
  * Method: `GET`
  * Parameter: `id`
  * Attack: `'`
  * Evidence: `You have an error in your SQL syntax`
  * Other Info: `RDBMS [MySQL] likely, given error message regular expression [\QYou have an error in your SQL syntax\E] matched by the HTML results.
The vulnerability was detected by manipulating the parameter to cause a database error message to be returned and recognised.`


Instances: 2

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

* URL: https://192.168.4.4/dvwa/vulnerabilities/csp/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/csp/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form name="csp" method="POST">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 1: "include" ].`
* URL: https://192.168.4.4/dvwa/vulnerabilities/exec/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/exec/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form name="ping" action="#" method="post">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 1: "ip" "Submit" ].`
* URL: https://192.168.4.4/dvwa/vulnerabilities/upload/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/upload/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form enctype="multipart/form-data" action="#" method="POST">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 1: "MAX_FILE_SIZE" "Upload" "uploaded" ].`
* URL: https://192.168.4.4/dvwa/vulnerabilities/weak_id/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/weak_id/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form method="post">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 1: "" ].`
* URL: https://192.168.4.4/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/xss_s/`
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

### [ Application Error Disclosure ](https://www.zaproxy.org/docs/alerts/90022/)



##### Medium (Medium)

### Description

This page contains an error/warning message that may disclose sensitive information like the location of the file that produced the unhandled exception. This information can be used to launch further attacks against the web application. The alert could be a false positive if the error message is found inside a documentation page.

* URL: https://192.168.4.4/dvwa/README.ar.md
  * Node Name: `https://192.168.4.4/dvwa/README.ar.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.es.md
  * Node Name: `https://192.168.4.4/dvwa/README.es.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.fa.md
  * Node Name: `https://192.168.4.4/dvwa/README.fa.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.fr.md
  * Node Name: `https://192.168.4.4/dvwa/README.fr.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.id.md
  * Node Name: `https://192.168.4.4/dvwa/README.id.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.it.md
  * Node Name: `https://192.168.4.4/dvwa/README.it.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.pl.md
  * Node Name: `https://192.168.4.4/dvwa/README.pl.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.pt.md
  * Node Name: `https://192.168.4.4/dvwa/README.pt.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.ru.md
  * Node Name: `https://192.168.4.4/dvwa/README.ru.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.tr.md
  * Node Name: `https://192.168.4.4/dvwa/README.tr.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.uk.md
  * Node Name: `https://192.168.4.4/dvwa/README.uk.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.vi.md
  * Node Name: `https://192.168.4.4/dvwa/README.vi.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.zh.md
  * Node Name: `https://192.168.4.4/dvwa/README.zh.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/instructions.php
  * Node Name: `https://192.168.4.4/dvwa/instructions.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/instructions.php%3Fdoc=readme
  * Node Name: `https://192.168.4.4/dvwa/instructions.php (doc)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Can't connect to local`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/upload/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/upload/ ()(MAX_FILE_SIZE,Upload,uploaded)`
  * Method: `POST`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<b>Warning</b>:  Undefined array key "uploaded" in <b>/var/www/html/vulnerabilities/upload/source/low.php</b> on line <b>6</b><br />`
  * Other Info: ``


Instances: 16

### Solution

Review the source code of this page. Implement custom error pages. Consider implementing a mechanism to provide a unique error reference/identifier to the client (browser) while logging the details on the server side and not exposing them to the user.

### Reference



#### CWE Id: [ 550 ](https://cwe.mitre.org/data/definitions/550.html)


#### WASC Id: 13

#### Source ID: 3

### [ CSP: Failure to Define Directive with No Fallback ](https://www.zaproxy.org/docs/alerts/10055/)



##### Medium (High)

### Description

The Content Security Policy fails to define one of the directives that has no fallback. Missing/excluding them is the same as allowing anything.

* URL: https://192.168.4.4/dvwa/vulnerabilities/csp/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/csp/`
  * Method: `GET`
  * Parameter: `Content-Security-Policy`
  * Attack: ``
  * Evidence: `script-src 'self' https://pastebin.com hastebin.com www.toptal.com example.com code.jquery.com https://ssl.google-analytics.com unpkg.com cdn.jsdelivr.net digi.ninja ;`
  * Other Info: `The directive(s): frame-ancestors, form-action is/are among the directives that do not fallback to default-src.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/csp/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/csp/ ()(include)`
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

* URL: https://192.168.4.4/dvwa/vulnerabilities/csp/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/csp/`
  * Method: `GET`
  * Parameter: `Content-Security-Policy`
  * Attack: ``
  * Evidence: `script-src 'self' https://pastebin.com hastebin.com www.toptal.com example.com code.jquery.com https://ssl.google-analytics.com unpkg.com cdn.jsdelivr.net digi.ninja ;`
  * Other Info: `The following directives either allow wildcard sources (or ancestors), are not defined, or are overly broadly defined:
style-src, img-src, connect-src, frame-src, font-src, media-src, object-src, manifest-src`
* URL: https://192.168.4.4/dvwa/vulnerabilities/csp/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/csp/ ()(include)`
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

* URL: https://192.168.4.4/dvwa/vulnerabilities/csp/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/csp/`
  * Method: `GET`
  * Parameter: `Content-Security-Policy`
  * Attack: ``
  * Evidence: `script-src 'self' https://pastebin.com hastebin.com www.toptal.com example.com code.jquery.com https://ssl.google-analytics.com unpkg.com cdn.jsdelivr.net digi.ninja ;`
  * Other Info: `style-src includes unsafe-inline.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/csp/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/csp/ ()(include)`
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

* URL: https://192.168.4.4/dvwa/
  * Node Name: `https://192.168.4.4/dvwa/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/index.php
  * Node Name: `https://192.168.4.4/dvwa/index.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/instructions.php
  * Node Name: `https://192.168.4.4/dvwa/instructions.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/brute/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/brute/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/fi/%3Fpage=include.php
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/fi/ (page)`
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

* URL: https://192.168.4.4/dvwa/
  * Node Name: `https://192.168.4.4/dvwa/`
  * Method: `GET`
  * Parameter: `x-frame-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/instructions.php
  * Node Name: `https://192.168.4.4/dvwa/instructions.php`
  * Method: `GET`
  * Parameter: `x-frame-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/brute/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/brute/`
  * Method: `GET`
  * Parameter: `x-frame-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/fi/%3Fpage=include.php
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/fi/ (page)`
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

### [ Cookie No HttpOnly Flag ](https://www.zaproxy.org/docs/alerts/10010/)



##### Low (Medium)

### Description

A cookie has been set without the HttpOnly flag, which means that the cookie can be accessed by JavaScript. If a malicious script can be run on this page then the cookie will be accessible and can be transmitted to another site. If this is a session cookie then session hijacking may be possible.

* URL: https://192.168.4.4/dvwa/vulnerabilities/weak_id/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/weak_id/`
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

* URL: https://192.168.4.4/dvwa/vulnerabilities/weak_id/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/weak_id/`
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

* URL: https://192.168.4.4/dvwa/vulnerabilities/weak_id/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/weak_id/`
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

* URL: https://192.168.4.4/dvwa/DTD/xhtml1-transitional.dtd
  * Node Name: `https://192.168.4.4/dvwa/DTD/xhtml1-transitional.dtd`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.68`
  * Other Info: `There is a chance that the highlight in the finding is on a value in the headers, versus the actual matched string in the response body.`
* URL: https://192.168.4.4/dvwa/compose.yml
  * Node Name: `https://192.168.4.4/dvwa/compose.yml`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.68`
  * Other Info: `There is a chance that the highlight in the finding is on a value in the headers, versus the actual matched string in the response body.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/csp/ZAP
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/csp/ZAP`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.68`
  * Other Info: `There is a chance that the highlight in the finding is on a value in the headers, versus the actual matched string in the response body.`


Instances: 3

### Solution

Configure the server to prevent such information leaks. For example:
Under Tomcat this is done via the "server" directive and implementation of custom error pages.
Under Apache this is done via the "ServerSignature" and "ServerTokens" directives.

### Reference


* [ https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/08-Testing_for_Error_Handling/ ](https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/08-Testing_for_Error_Handling/)


#### CWE Id: [ 497 ](https://cwe.mitre.org/data/definitions/497.html)


#### WASC Id: 13

#### Source ID: 3

### [ Information Disclosure - Debug Error Messages ](https://www.zaproxy.org/docs/alerts/10023/)



##### Low (Medium)

### Description

The response appeared to contain common error messages returned by platforms such as ASP.NET, and Web-servers such as IIS and Apache. You can configure the list of common debug messages.

* URL: https://192.168.4.4/dvwa/README.ar.md
  * Node Name: `https://192.168.4.4/dvwa/README.ar.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.es.md
  * Node Name: `https://192.168.4.4/dvwa/README.es.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.fa.md
  * Node Name: `https://192.168.4.4/dvwa/README.fa.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.fr.md
  * Node Name: `https://192.168.4.4/dvwa/README.fr.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.id.md
  * Node Name: `https://192.168.4.4/dvwa/README.id.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.it.md
  * Node Name: `https://192.168.4.4/dvwa/README.it.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.ko.md
  * Node Name: `https://192.168.4.4/dvwa/README.ko.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.pl.md
  * Node Name: `https://192.168.4.4/dvwa/README.pl.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.pt.md
  * Node Name: `https://192.168.4.4/dvwa/README.pt.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.ru.md
  * Node Name: `https://192.168.4.4/dvwa/README.ru.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.tr.md
  * Node Name: `https://192.168.4.4/dvwa/README.tr.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `or user 'notdvwa'@'loc`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.uk.md
  * Node Name: `https://192.168.4.4/dvwa/README.uk.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.vi.md
  * Node Name: `https://192.168.4.4/dvwa/README.vi.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/README.zh.md
  * Node Name: `https://192.168.4.4/dvwa/README.zh.md`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/instructions.php
  * Node Name: `https://192.168.4.4/dvwa/instructions.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/instructions.php%3Fdoc=readme
  * Node Name: `https://192.168.4.4/dvwa/instructions.php (doc)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access denied for user`
  * Other Info: ``


Instances: 16

### Solution

Disable debugging messages before pushing to production.

### Reference



#### CWE Id: [ 1295 ](https://cwe.mitre.org/data/definitions/1295.html)


#### WASC Id: 13

#### Source ID: 3

### [ Private IP Disclosure ](https://www.zaproxy.org/docs/alerts/2/)



##### Low (Medium)

### Description

A private IP (such as 10.x.x.x, 172.x.x.x, 192.168.x.x) or an Amazon EC2 private hostname (for example, ip-10-0-56-78) has been found in the HTTP response body. This information might be helpful for further attacks targeting internal systems.

* URL: https://192.168.4.4/dvwa/phpinfo.php
  * Node Name: `https://192.168.4.4/dvwa/phpinfo.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `172.18.0.4:80`
  * Other Info: `172.18.0.4:80
192.168.1.4
192.168.1.4
172.18.0.4
172.18.0.2
192.168.1.4
192.168.1.4
192.168.1.4
192.168.1.4
172.18.0.4
172.18.0.2
`
* URL: https://192.168.4.4/dvwa/vulnerabilities/fi/%3Fpage=file1.php
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/fi/ (page)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `172.18.0.2`
  * Other Info: `172.18.0.2
`


Instances: 2

### Solution

Remove the private IP address from the HTTP response body. For comments, use JSP/ASP/PHP comment instead of HTML/JavaScript comment which can be seen by client browsers.

### Reference


* [ https://datatracker.ietf.org/doc/html/rfc1918 ](https://datatracker.ietf.org/doc/html/rfc1918)


#### CWE Id: [ 497 ](https://cwe.mitre.org/data/definitions/497.html)


#### WASC Id: 13

#### Source ID: 3

### [ Server Leaks Information via "X-Powered-By" HTTP Response Header Field(s) ](https://www.zaproxy.org/docs/alerts/10037/)



##### Low (Medium)

### Description

The web/application server is leaking information via one or more "X-Powered-By" HTTP response headers. Access to such information may facilitate attackers identifying other frameworks/components your web application is reliant upon and the vulnerabilities such components may be subject to.

* URL: https://192.168.4.4/dvwa/
  * Node Name: `https://192.168.4.4/dvwa/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `X-Powered-By: PHP/8.5.11`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/index.php
  * Node Name: `https://192.168.4.4/dvwa/index.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `X-Powered-By: PHP/8.5.11`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/instructions.php
  * Node Name: `https://192.168.4.4/dvwa/instructions.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `X-Powered-By: PHP/8.5.11`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/brute/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/brute/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `X-Powered-By: PHP/8.5.11`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/fi/%3Fpage=include.php
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/fi/ (page)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `X-Powered-By: PHP/8.5.11`
  * Other Info: ``

Instances: Systemic


### Solution

Ensure that your web server, application server, load balancer, etc. is configured to suppress "X-Powered-By" headers.

### Reference


* [ https://owasp.org/www-project-web-security-testing-guide/v42/4-Web_Application_Security_Testing/01-Information_Gathering/08-Fingerprint_Web_Application_Framework ](https://owasp.org/www-project-web-security-testing-guide/v42/4-Web_Application_Security_Testing/01-Information_Gathering/08-Fingerprint_Web_Application_Framework)
* [ https://www.troyhunt.com/shhh-dont-let-your-response-headers/ ](https://www.troyhunt.com/shhh-dont-let-your-response-headers/)


#### CWE Id: [ 497 ](https://cwe.mitre.org/data/definitions/497.html)


#### WASC Id: 13

#### Source ID: 3

### [ Strict-Transport-Security Header Not Set ](https://www.zaproxy.org/docs/alerts/10035/)



##### Low (High)

### Description

HTTP Strict Transport Security (HSTS) is a web security policy mechanism whereby a web server declares that complying user agents (such as a web browser) are to interact with it using only secure HTTPS connections (i.e. HTTP layered over TLS/SSL). HSTS is an IETF standards track protocol and is specified in RFC 6797.

* URL: https://192.168.4.4/dvwa/
  * Node Name: `https://192.168.4.4/dvwa/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/index.php
  * Node Name: `https://192.168.4.4/dvwa/index.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/instructions.php
  * Node Name: `https://192.168.4.4/dvwa/instructions.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/brute/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/brute/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/fi/%3Fpage=include.php
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/fi/ (page)`
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

* URL: https://192.168.4.4/dvwa/phpinfo.php
  * Node Name: `https://192.168.4.4/dvwa/phpinfo.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1793640049`
  * Other Info: `1793640049, which evaluates to: 2026-11-02 17:20:49.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/javascript/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/javascript/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1732584193`
  * Other Info: `1732584193, which evaluates to: 2024-11-26 01:23:13.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/javascript/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/javascript/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1732584194`
  * Other Info: `1732584194, which evaluates to: 2024-11-26 01:23:14.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/javascript/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/javascript/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1770035416`
  * Other Info: `1770035416, which evaluates to: 2026-02-02 12:30:16.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/javascript/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/javascript/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1958414417`
  * Other Info: `1958414417, which evaluates to: 2032-01-22 20:00:17.`

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

* URL: https://192.168.4.4/dvwa/
  * Node Name: `https://192.168.4.4/dvwa/`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`
* URL: https://192.168.4.4/dvwa/index.php
  * Node Name: `https://192.168.4.4/dvwa/index.php`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`
* URL: https://192.168.4.4/dvwa/instructions.php
  * Node Name: `https://192.168.4.4/dvwa/instructions.php`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/brute/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/brute/`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/fi/%3Fpage=include.php
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/fi/ (page)`
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

* URL: https://192.168.4.4/dvwa/vulnerabilities/brute/%3FLogin=Login&password=ZAP&username=ZAP
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/brute/ (Login,password,username)`
  * Method: `GET`
  * Parameter: `Login`
  * Attack: ``
  * Evidence: `password`
  * Other Info: `userParam=Login
userValue=Login
passwordParam=password
referer=https://192.168.4.4/dvwa/vulnerabilities/brute/`


Instances: 1

### Solution

This is an informational alert rather than a vulnerability and so there is nothing to fix.

### Reference


* [ https://www.zaproxy.org/docs/desktop/addons/authentication-helper/auth-req-id/ ](https://www.zaproxy.org/docs/desktop/addons/authentication-helper/auth-req-id/)



#### Source ID: 3

### [ Information Disclosure - Sensitive Information in URL ](https://www.zaproxy.org/docs/alerts/10024/)



##### Informational (Medium)

### Description

The request appeared to contain sensitive information leaked in the URL. This can violate PCI and most organizational compliance policies. You can configure the list of strings for this check to add or remove values specific to your environment.

* URL: https://192.168.4.4/dvwa/vulnerabilities/brute/%3FLogin=Login&password=ZAP&username=ZAP
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/brute/ (Login,password,username)`
  * Method: `GET`
  * Parameter: `password`
  * Attack: ``
  * Evidence: `password`
  * Other Info: `The URL contains potentially sensitive information. The following string was found via the pattern: pass
password`
* URL: https://192.168.4.4/dvwa/vulnerabilities/brute/%3FLogin=Login&password=ZAP&username=ZAP
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/brute/ (Login,password,username)`
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

* URL: https://192.168.4.4/dvwa/vulnerabilities/javascript/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/javascript/`
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
* URL: https://192.168.4.4/dvwa/vulnerabilities/javascript/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/javascript/ ()(phrase,send,token)`
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

* URL: https://192.168.4.4/dvwa/
  * Node Name: `https://192.168.4.4/dvwa/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<a href="#" onclick="javascript:toggleTheme();" class="theme-icon" title="Toggle theme between light and dark.">
                    <img src="dvwa/images/theme-light-dark.png" alt="Damn Vulnerable Web Application" />
                </a>`
  * Other Info: `Links have been found that do not have traditional href attributes, which is an indication that this is a modern web application.`
* URL: https://192.168.4.4/dvwa/index.php
  * Node Name: `https://192.168.4.4/dvwa/index.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<a href="#" onclick="javascript:toggleTheme();" class="theme-icon" title="Toggle theme between light and dark.">
                    <img src="dvwa/images/theme-light-dark.png" alt="Damn Vulnerable Web Application" />
                </a>`
  * Other Info: `Links have been found that do not have traditional href attributes, which is an indication that this is a modern web application.`
* URL: https://192.168.4.4/dvwa/instructions.php
  * Node Name: `https://192.168.4.4/dvwa/instructions.php`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<a href="#" onclick="javascript:toggleTheme();" class="theme-icon" title="Toggle theme between light and dark.">
                    <img src="dvwa/images/theme-light-dark.png" alt="Damn Vulnerable Web Application" />
                </a>`
  * Other Info: `Links have been found that do not have traditional href attributes, which is an indication that this is a modern web application.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/brute/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/brute/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<a href="#" onclick="javascript:toggleTheme();" class="theme-icon" title="Toggle theme between light and dark.">
                    <img src="../../dvwa/images/theme-light-dark.png" alt="Damn Vulnerable Web Application" />
                </a>`
  * Other Info: `Links have been found that do not have traditional href attributes, which is an indication that this is a modern web application.`
* URL: https://192.168.4.4/dvwa/vulnerabilities/fi/%3Fpage=include.php
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/fi/ (page)`
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

* URL: https://192.168.4.4/dvwa/
  * Node Name: `https://192.168.4.4/dvwa/`
  * Method: `GET`
  * Parameter: `cache-control`
  * Attack: ``
  * Evidence: `no-cache, must-revalidate`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/index.php
  * Node Name: `https://192.168.4.4/dvwa/index.php`
  * Method: `GET`
  * Parameter: `cache-control`
  * Attack: ``
  * Evidence: `no-cache, must-revalidate`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/instructions.php
  * Node Name: `https://192.168.4.4/dvwa/instructions.php`
  * Method: `GET`
  * Parameter: `cache-control`
  * Attack: ``
  * Evidence: `no-cache, must-revalidate`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/brute/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/brute/`
  * Method: `GET`
  * Parameter: `cache-control`
  * Attack: ``
  * Evidence: `no-cache, must-revalidate`
  * Other Info: ``
* URL: https://192.168.4.4/dvwa/vulnerabilities/fi/%3Fpage=include.php
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/fi/ (page)`
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

### [ User Controllable HTML Element Attribute (Potential XSS) ](https://www.zaproxy.org/docs/alerts/10031/)



##### Informational (Low)

### Description

This check looks at user-supplied input in query string parameters and POST data to identify where certain HTML attribute values might be controlled. This provides hot-spot detection for XSS (cross-site scripting) that will require further review by a security analyst to determine exploitability.

* URL: https://192.168.4.4/dvwa/instructions.php%3Fdoc=readme
  * Node Name: `https://192.168.4.4/dvwa/instructions.php (doc)`
  * Method: `GET`
  * Parameter: `doc`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://192.168.4.4/dvwa/instructions.php?doc=readme

appears to include user input in:
a(n) [a] tag [href] attribute

The user input found was:
doc=readme

The user-controlled value was:
readme.ar.md`
* URL: https://192.168.4.4/dvwa/vulnerabilities/brute/%3FLogin=Login&password=ZAP&username=ZAP
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/brute/ (Login,password,username)`
  * Method: `GET`
  * Parameter: `Login`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://192.168.4.4/dvwa/vulnerabilities/brute/?Login=Login&password=ZAP&username=ZAP

appears to include user input in:
a(n) [input] tag [value] attribute

The user input found was:
Login=Login

The user-controlled value was:
login`
* URL: https://192.168.4.4/dvwa/vulnerabilities/sqli/%3FSubmit=Submit&id=ZAP
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/sqli/ (Submit,id)`
  * Method: `GET`
  * Parameter: `Submit`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://192.168.4.4/dvwa/vulnerabilities/sqli/?Submit=Submit&id=ZAP

appears to include user input in:
a(n) [input] tag [type] attribute

The user input found was:
Submit=Submit

The user-controlled value was:
submit`
* URL: https://192.168.4.4/dvwa/vulnerabilities/csp/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/csp/ ()(include)`
  * Method: `POST`
  * Parameter: `include`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://192.168.4.4/dvwa/vulnerabilities/csp/

appears to include user input in:
a(n) [script] tag [src] attribute

The user input found was:
include=ZAP

The user-controlled value was:
zap`
* URL: https://192.168.4.4/dvwa/vulnerabilities/exec/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/exec/ ()(Submit,ip)`
  * Method: `POST`
  * Parameter: `Submit`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://192.168.4.4/dvwa/vulnerabilities/exec/

appears to include user input in:
a(n) [input] tag [type] attribute

The user input found was:
Submit=Submit

The user-controlled value was:
submit`
* URL: https://192.168.4.4/dvwa/vulnerabilities/javascript/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/javascript/ ()(phrase,send,token)`
  * Method: `POST`
  * Parameter: `phrase`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://192.168.4.4/dvwa/vulnerabilities/javascript/

appears to include user input in:
a(n) [input] tag [value] attribute

The user input found was:
phrase=ChangeMe

The user-controlled value was:
changeme`
* URL: https://192.168.4.4/dvwa/vulnerabilities/javascript/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/javascript/ ()(phrase,send,token)`
  * Method: `POST`
  * Parameter: `send`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://192.168.4.4/dvwa/vulnerabilities/javascript/

appears to include user input in:
a(n) [input] tag [type] attribute

The user input found was:
send=Submit

The user-controlled value was:
submit`
* URL: https://192.168.4.4/dvwa/vulnerabilities/upload/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/upload/ ()(MAX_FILE_SIZE,Upload,uploaded)`
  * Method: `POST`
  * Parameter: `MAX_FILE_SIZE`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://192.168.4.4/dvwa/vulnerabilities/upload/

appears to include user input in:
a(n) [input] tag [value] attribute

The user input found was:
MAX_FILE_SIZE=100000

The user-controlled value was:
100000`
* URL: https://192.168.4.4/dvwa/vulnerabilities/upload/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/upload/ ()(MAX_FILE_SIZE,Upload,uploaded)`
  * Method: `POST`
  * Parameter: `Upload`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://192.168.4.4/dvwa/vulnerabilities/upload/

appears to include user input in:
a(n) [input] tag [name] attribute

The user input found was:
Upload=Upload

The user-controlled value was:
uploaded`
* URL: https://192.168.4.4/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/xss_s/ ()(btnClear,mtxMessage,txtName)`
  * Method: `POST`
  * Parameter: `btnClear`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://192.168.4.4/dvwa/vulnerabilities/xss_s/

appears to include user input in:
a(n) [input] tag [value] attribute

The user input found was:
btnClear=Clear Guestbook

The user-controlled value was:
clear guestbook`
* URL: https://192.168.4.4/dvwa/vulnerabilities/xss_s/
  * Node Name: `https://192.168.4.4/dvwa/vulnerabilities/xss_s/ ()(btnSign,mtxMessage,txtName)`
  * Method: `POST`
  * Parameter: `btnSign`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

https://192.168.4.4/dvwa/vulnerabilities/xss_s/

appears to include user input in:
a(n) [input] tag [value] attribute

The user input found was:
btnSign=Sign Guestbook

The user-controlled value was:
sign guestbook`


Instances: 11

### Solution

Validate all input and sanitize output it before writing to any HTML attributes.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)


#### CWE Id: [ 20 ](https://cwe.mitre.org/data/definitions/20.html)


#### WASC Id: 20

#### Source ID: 3


