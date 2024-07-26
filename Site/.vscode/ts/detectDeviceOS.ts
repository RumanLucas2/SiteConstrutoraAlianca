class OperacionalSistem
{
    private os: String;
    device: String;


    constructor(){
        this.setDevice();
        this.setOS();
    }

    private setOS(){
        this.os = this.detectOS();
    }

    private setDevice(){
        this.device = this.detectDevice();
    }

    get operationalSistem():String {
        return this.os;
    }

    get userDevice():String {
        return this.device;
    }

    detectDevice(): String {
        const userAgent = navigator.userAgent.toLowerCase();
        const isMobile = (userAgent.includes("mobile") || userAgent.includes("android") ||userAgent.includes("iphone") ||userAgent.includes("ipad") ||userAgent.includes("phone"));
        const isTablet = (userAgent.includes("ipad") || ((screen.width == 1024 && screen.height == 1366) || (screen.width == 1366 && screen.height == 1024)));
        const isDesktop = !isMobile && !isTablet;
    
        if (isDesktop) {
            return "Computer";
        } else if (isMobile) {
            return "Mobile";
        } else if (isTablet) {
            return "Tablet";
        } else {
            return "Unknown";
        }
    }
    
    detectOS(): String {
        const userAgent = navigator.userAgent.toLowerCase();
    
        // Windows detection
        if (userAgent.includes("windows nt 10.0")) return "Windows 10 or higher";
        if (userAgent.includes("windows nt 6.1")) return "Windows 7";
        if (userAgent.includes("windows nt 6.2")) return "Windows 8";
        if (userAgent.includes("windows nt 6.0")) return "Windows Vista";
        if (userAgent.includes("windows nt 6.3")) return "Windows 8.1";
        if (userAgent.includes("windows nt 5.1") || userAgent.includes("windows xp")) return "Windows XP or earlier";
    
        // Mac and iOS detection
        if (userAgent.includes("macintosh; intel mac os x")){
            const device = this.detectDevice() == "Tablet" ? "Mac OS for Ipad" : "Mac OS"
            return device;
        }
        if (userAgent.includes("iphone")) return "iOS iPhone";
        if (userAgent.includes("ipad")) return "iOS iPad";
        if (userAgent.includes("ipod")) return "iOS iPod";
        
        // Linux detection
        if (userAgent.includes("linux")) return "Linux";
        
        // Android detection
        if (userAgent.includes("android")) {
            if (userAgent.includes("mobile")) {
                return "Android Mobile";
            } else {
                return "Android Tablet";
            }
        }
    
        return "Unknown";
    } 
}
