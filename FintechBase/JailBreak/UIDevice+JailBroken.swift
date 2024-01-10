//
//  UIDevice+JailBroken.swift
//  FintechBase
//
//  Created by Ranjith Ravichandran on 18/07/22.
//

import Foundation
import UIKit

extension UIDevice {
    var isSimulator: Bool {
        TARGET_OS_SIMULATOR != 0
    }
    
    var isJailBroken: Bool {
            if UIDevice.current.isSimulator {
                return false }
            if JailBrokenHelper.checkURLSchemes() {
                return true }
            if JailBrokenHelper.isContainsSuspiciousApps() {
                return true }
            if JailBrokenHelper.isSuspiciousSystemPathsExists() {
                return true }
            return JailBrokenHelper.canEditSystemFiles()
    }
}

private struct JailBrokenHelper {
    
    static func checkURLSchemes() -> Bool {
        var flag: Bool!
        let urlSchemes = [
            "undecimus://",
            "sileo://",
            "zbra://",
            "filza://",
            "activator://",
            "cydia://"
        ]

        if Thread.isMainThread {
            flag = canOpenUrlFromList(urlSchemes: urlSchemes)
        } else {
            let semaphore = DispatchSemaphore(value: 0)
            DispatchQueue.main.async {
                flag = canOpenUrlFromList(urlSchemes: urlSchemes)
                semaphore.signal()
            }
            semaphore.wait()
        }
        return flag
    }
    
    private static func canOpenUrlFromList(urlSchemes: [String]) -> Bool {
        for urlScheme in urlSchemes {
            if let url = URL(string: urlScheme) {
                if UIApplication.shared.canOpenURL(url) {
                    return true
                }
            }
        }
        return false
    }
    
    static func isContainsSuspiciousApps() -> Bool {
        for path in suspiciousAppsPathToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    static func isSuspiciousSystemPathsExists() -> Bool {
        for path in suspiciousSystemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    static func canEditSystemFiles() -> Bool {
        let jailBreakText = "Developer Insider"
        do {
            try jailBreakText.write(toFile: jailBreakText, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
    /**
     Add more paths here to check for jail break
     */
    static var suspiciousAppsPathToCheck: [String] {
         ["/Applications/Cydia.app",
                "/Applications/blackra1n.app",
                "/Applications/FakeCarrier.app",
                "/Applications/Icy.app",
                "/Applications/IntelliScreen.app",
                "/Applications/MxTube.app",
                "/Applications/RockApp.app",
                "/Applications/SBSettings.app",
                "/Applications/WinterBoard.app",
                "/Applications/Snoop-itConfig.app",
                "/Applications/Checkra1n.app",
                "/Applications/HideJB.app",
                "/Applications/Sileo.app",
                "/Applications/FlyJB.app",
                "/Applications/Zebra.app"
        ]
    }
    
    static var suspiciousSystemPathsToCheck: [String] {
          ["/.bootstrapped_electra",
                "/.cydia_no_stash",
                "/.installed_unc0ver",
                "/bin/bash",
                "/bin/sh",
                "/bin.sh",
                "/etc/apt",
                "/etc/apt/sources.list.d/electra.list",
                "/etc/apt/sources.list.d/sileo.sources",
                "/etc/apt/undecimus/undecimus.list",
                "/etc/ssh/sshd_config",
                "/jb/amfid_payload.dylib",
                "/jb/jailbreakd.plist",
                "/jb/libjailbreak.dylib",
                "/jb/lzma",
                "/jb/offsets.plist",
                "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                "/Library/MobileSubstrate/MobileSubstrate.dylib",
                "/Library/dpkg/info/re.frida.server.list",
                "/Library/LaunchDaemons/re.frida.server.plist",
                "/Library/MobileSubstrate/CydiaSubstrate.dylib",
                "/Library/MobileSubstrate/HideJB.dylib",
                "/Library/PreferenceBundles/ABypassPrefs.bundle",
                "/Library/PreferenceBundles/FlyJBPrefs.bundle",
                "/Library/PreferenceBundles/HideJBPrefs.bundle",
                "/Library/PreferenceBundles/LibertyPref.bundle",
                "/Library/PreferenceBundles/ShadowPreferences.bundle",
                "/private/var/lib/apt",
                "/private/var/lib/apt/",
                "/private/var/lib/cydia",
                "/private/var/mobile/Library/SBSettings/Themes",
                "/private/var/stash",
                "/private/var/tmp/cydia.log",
                "/private/etc/apt",
                "/private/etc/dpkg/origins/debian",
                "/private/etc/ssh/sshd_config",
                "/private/var/cache/apt/",
                "/private/var/log/syslog",
                "/private/var/mobileLibrary/SBSettingsThemes/",
                "/private/var/Users/",
                "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                "/usr/bin/sshd",
                "/usr/libexec/sftp-server",
                "/usr/sbin/sshd",
                "/usr/libexec/ssh-keysign",
                "/usr/bin/cycript",
                "/usr/bin/ssh",
                "/usr/lib/libcycript.dylib",
                "/usr/lib/libhooker.dylib",
                "/usr/lib/libjailbreak.dylib",
                "/usr/lib/libsubstitute.dylib",
                "/usr/lib/substrate",
                "/usr/lib/TweakInject",
                "/usr/libexec/cydia/",
                "/usr/libexec/cydia/firmware.sh",
                "/usr/local/bin/cycrip",
                "/usr/sbin/frida-server",
                "/usr/share/jailbreak/injectme.plist",
                "/usr/lib/ABDYLD.dylib",
                "/usr/lib/ABSubLoader.dylib",
                "/var/binpack",
                "/var/cache/apt",
                "/var/checkra1n.dmg",
                "/var/lib/apt",
                "/var/lib/cydia",
                "/var/lib/dpkg/info/mobilesubstrate.md5sums",
                "/var/mobile/Library/Preferences/ABPattern",
                "/var/log/apt",
                "/var/log/syslog",
                "/var/tmp/cydia.log",
                "/var/binpack/Applications/loader.app"
        ]
    }
}
