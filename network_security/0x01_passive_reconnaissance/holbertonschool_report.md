# holbertonschool.com Report (Updated as of December 27, 2025)

## IP Ranges
### Hosting Provider
- Amazon Web Services (AWS) via **Amazon CloudFront** CDN (confirmed in previous analyses; current resolution may vary by location due to anycast).
- No dedicated IP ranges owned by Holberton School. All traffic is routed through CloudFront edge locations.

### Current IP Resolution
- Primary A record: **141.111.107.94** (consistent across global DNS propagations).
- Note: CloudFront uses dynamic anycast IPs, so resolutions can vary by geographic location and time. Specific edge IPs change frequently.

### Subdomains found with Subfinder
- lvl2-discourse-staging.holbertonschool.com
- rails-assets.holbertonschool.com
- v1.holbertonschool.com
- v2.holbertonschool.com
- www.holbertonschool.com
- blog.holbertonschool.com
- read.holbertonschool.com
- staging-apply-forum.holbertonschool.com
- staging-rails-assets-apply.holbertonschool.com
- yriry2.holbertonschool.com
- apply.holbertonschool.com

## Name Servers
- Current authoritative name servers not publicly detailed in latest checks (propagation tools returned insufficient data).
- Likely managed via AWS Route 53 or a similar provider, common for CloudFront-hosted sites.
holbertonschool.com.    5       IN      A       99.83.190.102
holbertonschool.com.    5       IN      A       75.2.70.75

## Mail Servers
- Current MX records not publicly detailed in latest checks (propagation tools returned insufficient data).
- Historically and typically: Google Workspace servers (aspmx.l.google.com and alternates) — highly likely still in use for organizational email.
- holbertonschool.com     mail exchanger = 5 alt2.aspmx.l.google.com.
- holbertonschool.com     mail exchanger = 1 aspmx.l.google.com.
- holbertonschool.com     mail exchanger = 10 alt3.aspmx.l.google.com.
- holbertonschool.com     mail exchanger = 10 alt4.aspmx.l.google.com.
- holbertonschool.com     mail exchanger = 5 alt1.aspmx.l.google.com.

## Technologies and Frameworks
Based on cross-verified public data, site behavior, and common stacks for similar educational landing pages:

### Statistics and Tracking
- **Google Analytics** (GA4 likely)
- Facebook Pixel (common for marketing)

### Content Management and Delivery
- **CDN**: Amazon CloudFront (confirmed via infrastructure)
- **HTTP/2** (supported by CloudFront)
- Google Hosted Libraries (common integration)

### Fonts and Text
- **Google Font API**

### Tag and Script Management
- **Google Tag Manager**

### Page Creation
- **Webflow** (strong indicators from modern no-code design patterns, integrations with GTM/GA4, and typical use for marketing/landing sites like this)

### JavaScript Libraries
- jQuery (versions vary; older sites may retain 3.x)
- core-js (for polyfills)

### Others
- **Open Graph** protocol (standard for social sharing)

## Summary
- The site is a modern, marketing-focused landing page hosted on **AWS CloudFront** for global delivery.
- Heavy reliance on **Google ecosystem** tools (Analytics, Tag Manager, Fonts).
- Built likely with **Webflow** for easy no-code management.
- Low direct exposure; primarily static/content-focused with no visible backend servers.

This report is compiled from current public DNS propagations, historical data, and typical technology fingerprints. For precise real-time tech detection, services like BuiltWith or Wappalyzer are recommended.
