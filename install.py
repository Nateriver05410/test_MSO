import os
import platform
import subprocess
import sys
import zipfile
import shutil
from urllib.request import urlretrieve

def run(cmd):
    print(f"▶ {cmd}")
    subprocess.run(cmd, shell=True, check=True)

def pip_install():
    print("📦 Installing Robot Framework and Selenium...")
    run(f"{sys.executable} -m pip install --upgrade pip")
    run(f"{sys.executable} -m pip install robotframework selenium robotframework-seleniumlibrary")

def download_and_install_chromedriver():
    system = platform.system()
    arch = platform.machine()

    print(f"🖥️ Detected OS: {system}, Arch: {arch}")

    version = "138.0.7204.157"

    if system == "Darwin":
        if arch == "arm64":
            driver_url = f"https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/{version}/mac-arm64/chromedriver-mac-arm64.zip"
        else:
            driver_url = f"https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/{version}/mac-x64/chromedriver-mac-x64.zip"
        driver_name = "chromedriver"
    elif system == "Windows":
        driver_url = f"https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/{version}/win32/chromedriver-win32.zip"
        driver_name = "chromedriver.exe"
    else:
        print("❌ Unsupported OS")
        return

    print(f"🌐 Downloading ChromeDriver from {driver_url}")
    zip_path = "chromedriver.zip"
    urlretrieve(driver_url, zip_path)

    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall("chromedriver_extracted")
    os.remove(zip_path)

    extracted_path = os.path.join("chromedriver_extracted", "chromedriver", driver_name)

    if system == "Windows":
        target_path = os.path.join(os.getcwd(), driver_name)
    else:
        target_path = "/usr/local/bin/chromedriver"

    shutil.move(extracted_path, target_path)
    os.chmod(target_path, 0o755)
    shutil.rmtree("chromedriver_extracted")

    print(f"✅ ChromeDriver installed to: {target_path}")

def main():
    pip_install()
    download_and_install_chromedriver()
    print("\n✅ Installation complete!")
    print("You can now run your test with:")
    print("   robot test_login_logout.robot")

if __name__ == "__main__":
    main()