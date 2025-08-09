# shim to replace the old chromedrivermanager on Linux
from webdriver_manager.chrome import ChromeDriverManager as _ChromeDriverManager

class ChromeDriverManager(_ChromeDriverManager):
    pass
