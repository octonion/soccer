//Performgroup functions
// 27.04.2015 - 10:49
(function (window)
{
    var PATH_HTTP_BASE           = "http://static.eplayer.performgroup.com";
    var PATH_HTML5_ORIGINAL      = "http://www.eplayerhtml5.performgroup.com/tsindex.html";
    var PATH_HTML5               = PATH_HTML5_ORIGINAL;
    var PATH_FLASH               = "http://static.eplayer.performgroup.com/ptvFlash/eplayer2/Eplayer.swf";
    var PATH_TESTAREA            = "http://static.eplayer.performgroup.com/ptvFlash/eplayer2/testarea/";
    var PATH_WARNING_IMAGE       = "http://static.eplayer.performgroup.com/ptvFlash/eplayer2/data/images/flashandhtml5warning.jpg";
    var PATH_CONFIG_XML          = "http://xml.eplayer.performgroup.com/eplayer/config/";
    var PATH_DATA                = "http://static.eplayer.performgroup.com/ptvFlash/eplayer2/data/";
    var PATH_LOGSYSTEM           = "http://www.performgroup.com/ptvFlash/eplayer2/testarea/EplayerLogging/";
    var PATH_ASSETS              = "http://static.eplayer.performgroup.com/ptvFlash/eplayer2/assets/";
    var PATH_RULES               = "http://static.eplayer.performgroup.com/ptvFlash/eplayer2/data/xml/customRules/customRulesFLASH.xml";
    var QUERY_PARAM_SWF_URL      = 'eplayerswfurl';
    var QUERY_PARAM_DEBUG        = 'eplayerdebug';
    var QUERY_PARAM_LOGPATH      = 'eplayerlogbasepath';
    var QUERY_PARAM_SWF_FULL     = 'eplayerswfurlpath';
    var QUERY_PARAM_HTML5_PATH   = 'eplayerhtml5path';
    var QUERY_PARAM_ASSETS_PATH  = 'eplayerassetspath';
    var QUERY_PARAM_JS_PATH      = 'eplayerjspath';
    var QUERY_PARAM_FORCE_HTML5  = 'eplayerforcehtml5';
    var QUERY_PARAM_RULES        = 'eplayercustomrules';
    var QUERY_PARAM_LIVERAIL     = 'eplayerdisableliverail';
    var HEIGHTS_BANNER           = [45, 60 , 60 , 60 , 60, 45 , 60 , 60, 60, 45 , 45, 60 , 60, 60 , 60, 60 , 60, 60, 60, 60, 0  , 60, 60, 0 , 45, 60, 60, 60, 0 , 0 , 0  , 0, 0, 0, 0, 0, 0, 0, 0, 60, 60, 60, 0 , 0, 0, 60, 0, 60, 0, 60];
    var HEIGHTS_CAROUSEL         = [18, 130, 130, 130, 18, 130, 130, 18, 0 , 100, 18, 120, 18, 140, 18, 160, 18, 0 , 0 , 18, 130, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 18, 0 , 120, 0, 0, 0, 0, 0, 0, 0, 0, 102, 0, 0, 0, 0, 102, 0, 0, 0, 0, 0];
    var HEIGHTS_CONTROL_BAR      = [26 , 26 , 36 , 36 , 26 , 26 , 36 , 36 , 36 , 26 , 26 , 26 , 26 , 36 , 36 , 36 , 36 , 0, 0, 36 , 36 , 36 , 36 , 36 , 26 , 36 , 36 , 36 , 36 , 36 , 36, 0, 0, 0, 0, 0, 0, 0, 0, 36, 36, 36, 36, 36, 36, 36, 0, 36, 0, 36];
    var RESIZABLE_PLAYERS        = [0, 0, 0, 0, 0, 0, 0, 0, 0 , 1, 1, 1, 1, 1, 1, 1, 1, 0 , 0 , 1, 0, 1 , 0 , 1 , 1 , 1 , 1 , 1 , 1, 1 , 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1];
    var EPLAYER_WIDTHS           = [225, 300, 380, 620, 300, 201, 516, 380, 570, 225, 225, 280, 280, 380, 380, 620, 620, 0, 0, 620, 480, 620, 510, 620, 225, 380, 380, 425, 600, 600, 480, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1];
    var EPLAYER_HEIGHTS          = [190, 360, 405, 540, 247, 290, 481, 294, 380, 272, 190, 338, 236, 414, 294, 569, 427, 0, 0, 427, 400, 413, 347, 350, 182, 274, 274, 300, 364, 338, 400, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1];
    var WINDOW_FEATURES          = "menubar=yes,location=yes,resizable=yes,scrollbars=yes,status=yes";
    var PLAYER_COUNT             = 50;
    var USER_LOCATION_SERVICE	 = getUserLocationServiceURL();
    var userLocation             = "en";

    function getUserLocationServiceURL()
    {
        if(window.location.protocol == 'https:')
        {
            return "https://secure-geolocation.premiumtv.co.uk/page/userLocation/country/results.jsonp";
        }
        else
        {
            return "http://www.geolocation.performgroup.com/page/userLocation/country/results.jsonp";
        }
    }

    function loadUserLocationScript()
    {
        try
        {
            var script = document.createElement("script");

            script.src = USER_LOCATION_SERVICE;
            document.getElementsByTagName("head")[0].appendChild(script);
        }
        catch(error)
        {
            //nothing to do
        }
    }

    function userLocationServerCallback(data)
    {
        if(data && data.location)
        {
            userLocation = data.location;
        }
    }

    function setPlayerPaths(playerType)
    {
        PATH_HTML5               = isSecurePage(playerType) ? "https://sec-static.eplayer.performgroup.com/ptvFlash/eplayer2/EplayerHTML5/trunk/index.html" : PATH_HTML5_ORIGINAL;
        PATH_HTTP_BASE           = isSecurePage(playerType) ? "https://sec-static.eplayer.performgroup.com" : "http://static.eplayer.performgroup.com";
        PATH_FLASH               = PATH_HTTP_BASE + "/ptvFlash/eplayer2/Eplayer.swf";
        PATH_TESTAREA            = PATH_HTTP_BASE + "/ptvFlash/eplayer2/testarea/";
        PATH_WARNING_IMAGE       = PATH_HTTP_BASE + "/ptvFlash/eplayer2/data/images/flashandhtml5warning.jpg";
        PATH_DATA                = PATH_HTTP_BASE + "/ptvFlash/eplayer2/data/";
        PATH_ASSETS              = PATH_HTTP_BASE + "/ptvFlash/eplayer2/assets/";
        PATH_RULES               = PATH_HTTP_BASE + "/ptvFlash/eplayer2/data/xml/customRules/customRulesFLASH.xml";
        PATH_LOGSYSTEM           = PATH_HTTP_BASE + "/ptvFlash/eplayer2/testarea/EplayerLogging/";
        PATH_CONFIG_XML          = isSecurePage(playerType) ? "https://xml.eplayer.performgroup.com/eplayer/config/" : "http://xml.eplayer.performgroup.com/eplayer/config/";
    }

    function isSecurePage(playerType)
    {
        if(playerType === "eplayer48" && window && window.location && window.location.protocol)
        {
            return window.location.protocol == 'https:';
        }

        return false;
    }

    function getUrlVars ()
    {
        var vars    = [], hash;
        var href    = window.location.href;
        var hashes  = href.slice(href.indexOf('?') + 1).split('&');

        for(var i = 0; i < hashes.length; i++)
        {
            hash = hashes[i].split('=');

            var paramName = hash[0].toLowerCase();

            vars.push(paramName);
            vars[paramName] = hash[1];
        }

        return vars;
    };

    function FlashParameters(isDebug, customSettings)
    {
        this.isDebug              = isDebug;
        this.customSettings       = customSettings;
        this.scale                = "noscale";
        this.wmode                = "opaque";
        this.base                 = PATH_DATA;
        this.bgcolor              = "#000000";
        this.allowfullscreen      = "true";
        this.allowscriptaccess    = "always";
        this.alignment            = "TL";

        this.getWMode = function(customSettings)
        {
            var wmode = "window";

            if(customSettings != null && customSettings.wmode != null)
            {
                wmode = customSettings.wmode;
            }
            else if(window.params != null && window.params.wmode != null)
            {
                wmode = window.params.wmode;
            }

            return wmode;
        };

        this.init = function()
        {
            this.wmode = this.isDebug ? "opaque" : this.getWMode(this.customSettings);
        };

        this.init();
    }

    function ePlayer(channelId, videoUUId, partnerId, divNameString, autoPlay, startMute, playerId, playerType, customSettings)
    {
        this.channelId              = channelId;
        this.videoUUId              = videoUUId;
        this.partnerId              = partnerId;
        this.autoPlay               = autoPlay;
        this.startMute              = startMute;
        this.playerId               = playerId;
        this.eplayerID              = divNameString;
        this.customSettings         = customSettings;
        this.attributes             = {id:divNameString, name:divNameString};
        this.playerType             = playerType;
        this.divContent             = [];
        this.onView                 = false;
        this.isEmbeded              = false;
        this.configXML              = customSettings && customSettings.xmlPath ? customSettings.xmlPath + playerId : PATH_CONFIG_XML + playerId;
        this.referrer               = window.location.hostname;
        this.assetsPath             = PATH_ASSETS;
        this.dataPath               = PATH_DATA;
        this.isForceHTML5           = false;
        this.isFullSizeOn           = false;
        this.parentHtmlElement      = null;
        this.isFullSizeOnError      = false;
        this.isFullSizeOffError     = false;
        this.disableliverail        = false;
        this.isConfigLoaded         = false;
        this.isAutoplay             = false;
        this.isScrollToPlay         = false;
        this.isSecurePage           = isSecurePage(playerType);
        this.prevWidth              = 0;

        if(customSettings)
        {
            this.isOverRider         = customSettings.autoHide                  ? customSettings.autoHide            : false;
            this.age                 = customSettings.age                       ? customSettings.age                 : 0;
            this.mobilewidgetplayer  = customSettings.mobilewidgetplayer        ? customSettings.mobilewidgetplayer  : false;
            this.isForceHTML5        = customSettings.isForceHTML5              ? customSettings.isForceHTML5        : false;
        }
        else
        {
            this.isOverRider    = false;
            this.age            = 0;
        }

        this.init = function()
        {
            this.index = this.getIndexFromPlayerType();

            this.initFromQueryParams();
            this.initFromSettings();
            this.setInitialSizeFromContants();
            this.setInitialSizeFromCustomSettings();
            this.setInitialSizeFromParent();
            this.hideContent();
        };

        this.initFromSettings = function()
        {
            this.params         = new FlashParameters(this.debugMode,  this.customSettings);
            this.resizeMode     = this.customSettings && this.customSettings.resizeMode ? this.customSettings.resizeMode : false;
            this.locale         = this.customSettings && customSettings.locale          ? customSettings.locale          : "";
            this.country        = this.customSettings && customSettings.country         ? customSettings.country         : "";
            this.customRulesPath= this.customSettings && customSettings.customRulesPath ? customSettings.customRulesPath : PATH_RULES;
            this.isForceHTML5   = this.customSettings && this.customSettings.isForceHTML5 === true ? true : this.isForceHTML5;
        };

        this.initFromQueryParams = function()
        {
            this.hash           = getUrlVars();
            this.swfUrlPath     = this.hash[QUERY_PARAM_SWF_FULL]    ? this.hash[QUERY_PARAM_SWF_FULL ]               : "";
            this.html5Path      = this.hash[QUERY_PARAM_HTML5_PATH]  ? this.hash[QUERY_PARAM_HTML5_PATH]              : PATH_HTML5;
            this.assetsPath     = this.hash[QUERY_PARAM_ASSETS_PATH] ? this.hash[QUERY_PARAM_ASSETS_PATH]             : PATH_ASSETS;
            this.swfUrl         = this.hash[QUERY_PARAM_SWF_URL]     ? PATH_TESTAREA + this.hash[QUERY_PARAM_SWF_URL] : PATH_FLASH;
            this.logBasePath    = this.hash[QUERY_PARAM_LOGPATH ]    ? this.hash[QUERY_PARAM_LOGPATH  ]               : PATH_LOGSYSTEM;
            this.debugMode      = this.hash[QUERY_PARAM_DEBUG] === "true";
            this.swfUrl         = this.swfUrlPath ? this.swfUrlPath : this.swfUrl;
            this.javascriptPath = this.hash[QUERY_PARAM_JS_PATH]      ? this.hash[QUERY_PARAM_JS_PATH] : "";
            this.isForceHTML5   = this.hash[QUERY_PARAM_FORCE_HTML5] === "true" ? true : this.isForceHTML5;
            this.customRulesPath= this.hash[QUERY_PARAM_RULES ]    ? this.hash[QUERY_PARAM_RULES  ] : PATH_RULES;
            this.disableliverail= this.hash[QUERY_PARAM_LIVERAIL] ? this.hash[QUERY_PARAM_LIVERAIL  ] : false;

            PATH_RULES = this.customRulesPath;
        };

        this.setInitialSizeFromContants = function()
        {
            this.SWFWidth       = EPLAYER_WIDTHS [this.index];
            this.SWFHeight      = EPLAYER_HEIGHTS[this.index];
        };

        this.setInitialSizeFromCustomSettings = function()
        {
            this.SWFWidth       = isCustomPlayer(this.playerType) && this.customSettings && this.customSettings.width  ? this.customSettings.width  : this.SWFWidth;
            this.SWFHeight      = isCustomPlayer(this.playerType) && this.customSettings && this.customSettings.height ? this.customSettings.height : this.SWFHeight;
        };

        this.setInitialSizeFromParent = function()
        {
            if(this.resizeMode)
            {
                var calculatedSize = this.calculateEplayerSize();

                this.SWFWidth  =  calculatedSize.width;
                this.SWFHeight =  calculatedSize.height;
            }
        };

        this.hideContent = function()
        {
            var content = this.getHtmlElement();

            if(content != null)
            {
                for(var i = 0; i < content.children.length;i++)
                {
                    var child = content.children[i];

                    this.divContent.push(child);

                    content.removeChild(child);
                }
            }
        };

        this.showContent = function()
        {
            var content = this.getHtmlElement();

            if(content != null)
            {
                for(var i = 0; i < this.divContent.length;i++)
                {
                    content.appendChild(this.divContent[i]);
                }
            }
        };

        this.getIndexFromPlayerType = function()
        {
            var index = 0;

            if(playerType)
            {
                try
                {
                    index = parseInt(this.playerType.toLowerCase().replace("eplayer", ""));
                    index--;
                }
                catch(error)
                {
                    //nothing to do
                }
            }

            return index;
        };

        this.calculateVideoWidth = function(element)
        {
            var ret         = 360;
            var offsetWidth = null;

            try
            {
                offsetWidth = element.offsetWidth;
            }
            catch(error)
            {
                //nothing to do
            }

            if(offsetWidth)
            {
                ret = Number(offsetWidth);
            }

            return ret;
        };

        this.getHtmlElement = function()
        {
            return  document.getElementById(this.eplayerID);
        };

        this.getParentHtmlElement = function()
        {
            if(!this.parentHtmlElement && this.getHtmlElement())
            {
                this.parentHtmlElement = this.getHtmlElement().parentNode;
            }

            return  this.parentHtmlElement;
        };

        this.calculateEplayerSize = function()
        {
            var size                = { width  : 640, height : 640 };
            var element             = this.getHtmlElement();
            var bannerHeight        = HEIGHTS_BANNER  [this.index];
            var carouselHeight      = HEIGHTS_CAROUSEL[this.index];
            var controlBarHeight    = HEIGHTS_CONTROL_BAR [this.index];

            if(element && element.parentNode)
            {
                var videoWidth  = this.calculateVideoWidth(element.parentNode);
                var videoHeight = (videoWidth * 9) / 16;

                size.width  = Math.round(videoWidth);
                size.height = Math.round(bannerHeight + videoHeight + carouselHeight + controlBarHeight);
            }

            return size;
        };

        this.resizeToParent = function()
        {
            var element   = this.getHtmlElement();
            var size      = this.calculateEplayerSize();

            if(element && this.prevWidth != size.width)
            {
                element.style.width   = size.width  + "px";
                element.style.height  = size.height + "px";
                this.prevWidth = size.width;
            }
        };

        this.prevWidth = 0;

        this.showFlashAndHtml5Warning = function()
        {
            var content = this.getHtmlElement();

            if(content != null)
            {
                var img = document.createElement("img");

                img.src = PATH_WARNING_IMAGE;

                content.appendChild(img);
            }
        };

        this.postFullSizeOnMessage = function()
        {
            var element = this.getHtmlElement();

            if(element && element.contentWindow)
            {
                element.contentWindow.postMessage("onFullSizeOn", "*");
            }
            else if(element)
            {
                element.onFullSizeOn();
            }
        }

        this.postFullSizeOffMessage = function()
        {
            var element = this.getHtmlElement();

            if(element && element.contentWindow)
            {
                element.contentWindow.postMessage("onFullSizeOff", "*");
            }
            else if(element)
            {
                element.onFullSizeOff();
            }
        }

        this.toggleFullSize = function()
        {
            clearResizeInterval();

            try
            {
                this.isFullSizeOn = !this.isFullSizeOn;

                if(this.getHtmlElement())
                {
                    if(this.isFullSizeOn)
                    {
                        this.setFullSizeOn();
                    }
                    else
                    {
                        this.setFullSizeOff();
                    }
                }
                else
                {
                    if(this.isFullSizeOn)
                    {
                        this.isFullSizeOnError = true;
                    }
                    else
                    {
                        this.isFullSizeOffError = true;
                    }
                }
            }
            catch(error)
            {
                if(console && console.error)
                {
                    console.error(error);
                }
            }

            startResizeInterval();
        }

        this.setFullSizeOn = function()
        {
            this.isFullSizeOnError = false;

            try
            {
                this.saveElementStyles();
                this.resizeToWindow();
                this.showFullscreenBackground();
                this.postFullSizeOnMessage();
            }
            catch(error)
            {
                this.isFullSizeOnError = true;
            }
        }

        this.saveElementStyles = function()
        {
            this.saveElementStyle(this.getHtmlElement());
            this.saveElementStyle(this.getParentHtmlElement());
        }

        this.setFullSizeOff = function()
        {
            this.isFullSizeOffError = false;

            try
            {
                this.resizeToNormal();
                this.hide(document.getElementById("eplayerBack"));
                this.postFullSizeOffMessage();
            }
            catch(error)
            {
                this.isFullSizeOffError = true;
            }
        }

        this.resizeToNormal = function()
        {
            this.restoreElementStyle(this.getHtmlElement());
            this.restoreElementStyle(this.getParentHtmlElement());
        }

        this.saveElementStyle = function(element)
        {
            if(!element || !element.style)
            {
                throw new Error("Save not success!");
            }

            if(element && !element.oldStyle)
            {
                element.oldStyle = {};

                element.oldStyle.position        = element.style.position;
                element.oldStyle.width           = element.style.width;
                element.oldStyle.height          = element.style.height;
                element.oldStyle.top             = element.style.top;
                element.oldStyle.left            = element.style.left;
                element.oldStyle.zIndex          = element.style.zIndex;
            }
        }

        this.restoreElementStyle = function(element)
        {
            if(!element || !element.style)
            {
                throw new Error("Restore not success!");
            }

            if(element && element.oldStyle)
            {
                element.style.position        = element.oldStyle.position;
                element.style.width           = element.oldStyle.width;
                element.style.height          = element.oldStyle.height;
                element.style.top             = element.oldStyle.top;
                element.style.left            = element.oldStyle.left;
                element.style.zIndex          = element.oldStyle.zIndex;
            }
            else if(element)
            {
                element.removeAttribute("style");
            }
        }

        this.showFullscreenBackground = function ()
        {
            var back    = document.getElementById("eplayerBack");
            var element = this.getHtmlElement();

            if(!back)
            {
                back                        = document.createElement("div");
                back.id                     = "eplayerBack";
                back.style.position         = "fixed";
                back.style.width            = "100%";
                back.style.height           = "100%";
                back.style.left             = "0";
                back.style.top              = "0";
                back.style.backgroundColor  = "#000";
                back.style.opacity          = 0.7;
                back.style.zIndex           = 10000;

                document.body.appendChild(back);
            }

            back.eplayer = this;
            back.onclick = function()
            {
                this.eplayer.toggleFullSize();
                this.onclick = null;
            };

            this.show(back);
        }

        this.hide = function (element)
        {
            if(element)
            {
                element.style.display = "none";
            }
        }

        this.show = function (element)
        {
            if(element)
            {
                element.style.display = "";
            }
        }

        this.resizeToWindow = function ()
        {
            if(this.isFullSizeOn)
            {
                var w                   = window.innerWidth;
                var h                   = window.innerHeight;
                var element             = this.getHtmlElement().parentNode;
                var size                = this.calculateFullSize();
                var top                 = 0;
                var left                = 0;
                var controlBarHeight    = 36;
                var maxHeight           = h - 20 - controlBarHeight;

                if(size.height + controlBarHeight > maxHeight)
                {
                    size.width  = (maxHeight - controlBarHeight) * (size.width / size.height);
                    size.height = maxHeight - controlBarHeight;
                }

                this.floorSize(size);

                size.height += controlBarHeight;

                left = (w - size.width ) / 2;
                top  = (h - size.height) / 2;

                if(element)
                {
                    element.style.position  = "fixed";
                    element.style.width     = size.width  + "px";
                    element.style.height    = size.height + "px";
                    element.style.top       = top  + "px";
                    element.style.left      = left + "px";
                    element.style.zIndex    = 10001;

                    this.prevWidth = size.width;
                }

                if(this.getHtmlElement())
                {
                    element = this.getHtmlElement();

                    element.style.width     = size.width  + "px";
                    element.style.height    = size.height + "px";
                    element.style.top       = 0 + "px";
                    element.style.left      = 0 + "px";
                }
            }
        }

        this.floorSize = function(size)
        {
            size.width  = Math.floor(size.width);
            size.height = Math.floor(size.height);
        }

        this.calculateFullSize = function()
        {
            var size = {};

            size.width  =  window.innerWidth * 0.8;
            size.height =  (size.width * 9) / 16;

            return size;
        }

        this.init();
    }

    //global variables
    window.ePlayers                 = window.ePlayers                   ? window.ePlayers                   : [];
    window.eplayerExternalJSLoaded  = window.eplayerExternalJSLoaded    ? window.eplayerExternalJSLoaded    : false;
    window.isLogSystemLoaded        = window.isLogSystemLoaded          ? window.isLogSystemLoaded          : false;
    window.isAutoHideEnabled        = window.isAutoHideEnabled          ? window.isAutoHideEnabled          : false;
    window.overRidePlayer           = window.overRidePlayer             ? window.overRidePlayer             : false;
    window.isResizeListenerAvailable= window.isResizeListenerAvailable  ? window.isResizeListenerAvailable  : true;

    //closure variables
    var isEmbedding           = false;
    var WindowObjectReference = null;
    var currentPlayer         = null;

    function addPlayer(channelId, videoUUId, partnerId,  divNameString,  autoPlay, startMute,  playerId, playerType, customSettings)
    {
        loadLogSystem();

        if(isEmbedding || isLogSystemLoading())
        {
            setTimeout(function()
            {
                window.addPlayer(channelId,videoUUId,partnerId,divNameString,autoPlay,startMute,playerId,playerType,customSettings);
            }, 100);

            return;
        }

        try
        {
            setPlayerPaths(playerType);
            startEmbedTimeout();
            isEmbedding    = true;
            currentPlayer  = new ePlayer(channelId, videoUUId, partnerId, divNameString, autoPlay, startMute, playerId, playerType, customSettings);

            if(currentPlayer.javascriptPath && !window.eplayerExternalJSLoaded)
            {
                var script = document.createElement('script');

                script.setAttribute("type"  ,"text/javascript");
                script.setAttribute("src"   , currentPlayer.javascriptPath);

                script.onload = script.onreadystatechange = function()
                {
                    if (!this.readyState || this.readyState === "loaded" || this.readyState === "complete")
                    {
                        window.eplayerExternalJSLoaded = true;
                        window.addPlayer(channelId,videoUUId,partnerId,divNameString,autoPlay,startMute,playerId,playerType,customSettings);

                        isEmbedding = false;
                    }
                };

                document.getElementsByTagName("head")[0].appendChild(script);

                return;
            }

            var canShowThis = window.isAutoHideEnabled ? canShowThisPlayer() : true;
            if( window.ePlayers.length < 1 || canShowThis )
            {
                if(currentPlayer.isOverRider)
                {
                    window.isAutoHideEnabled = true;
                    window.overRidePlayer = currentPlayer;
                    hideOtherPlayers();
                    showEplayerHolder(currentPlayer.getHtmlElement().parentNode);
                }

                removeEplayer(currentPlayer.eplayerID);
                window.ePlayers.push(currentPlayer);

                var flashVars = cleanFromFunctions(currentPlayer);

                if(currentPlayer.isForceHTML5)
                {
                    addHTML5Player();
                    currentPlayer.isEmbeded = true;
                    isEmbedding = false;
                }
                else
                {
                    swfobject.embedSWF(currentPlayer.swfUrl, currentPlayer.eplayerID, currentPlayer.SWFWidth, currentPlayer.SWFHeight, "10", false, flashVars, currentPlayer.params, currentPlayer.attributes, alertStatus);
                }

                startCheckinOnView();
            }
            else{
                isEmbedding = false;
                return;
            }

        }
        catch(error)
        {
            isEmbedding = false;
        }
    }

    function startEmbedTimeout()
    {
        setTimeout(function()
        {
            isEmbedding = false;
        }, 5000);
    }

    function isLogSystemLoading()
    {
        return window.isLogSystemLoaded && (!window.eplayerLogManager || !window.eplayerLogManager.isJQueryLoaded);
    }

    function cleanFromFunctions(p_object){
        var returnObject = {};

        for(var field in p_object){

            if(typeof p_object[field] != "function")
                returnObject[field] = p_object[field];
        }

        return returnObject;
    }

    function addPreviewPlayer(channelId, videoUUId, partnerId,  divNameString,  autoPlay, startMute,  playerId, playerType, customSettings)
    {
        addPlayer(channelId, videoUUId, partnerId,  divNameString,  autoPlay, startMute,  playerId, playerType, customSettings);
    }

    function canShowThisPlayer()
    {
        var canShow           = true;
        var thisWidth       = currentPlayer.SWFWidth;
        var overRideWidth = window.overRidePlayer.SWFWidth;

        if(thisWidth < overRideWidth)
        {
            canShow = false;
        }
        else if(thisWidth == overRideWidth)
        {
            canShow = (window.overRidePlayer.age < currentPlayer.age);
        }

        return canShow;
    }

    function hideOtherPlayers()
    {
        for(var i = 0; i < window.ePlayers.length; i++)
        {
            var toRemove =  document.getElementById(window.ePlayers[i].eplayerID);

            if(toRemove)
            {
                if(!window.ePlayers[i].isOverRider)
                {
                    if(window.ePlayers[i].SWFWidth < window.overRidePlayer.SWFWidth)
                    {
                        hideEplayerHolder(toRemove.parentNode);
                        toRemove.parentNode.removeChild(toRemove);
                    }
                    else if(window.ePlayers[i].SWFWidth == window.overRidePlayer.SWFWidth)
                    {
                        if(window.ePlayers[i].age < window.overRidePlayer.age)
                        {
                            hideEplayerHolder(toRemove.parentNode);
                            toRemove.parentNode.removeChild(toRemove);
                            removeEplayer(window.ePlayers[i].eplayerID);
                        }
                    }
                }
                else
                {
                    if(window.ePlayers[i].SWFWidth < window.overRidePlayer.SWFWidth){
                        hideEplayerHolder(toRemove.parentNode);
                        toRemove.parentNode.removeChild(toRemove);
                        removeEplayer(window.ePlayers[i].eplayerID);
                    }
                    else if(window.ePlayers[i].SWFWidth == window.overRidePlayer.SWFWidth){
                        if(window.ePlayers[i].age < window.overRidePlayer.age)
                        {
                            hideEplayerHolder(toRemove.parentNode);
                            toRemove.parentNode.removeChild(toRemove);
                            removeEplayer(window.ePlayers[i].eplayerID);
                        }
                    }
                }
            }
        }
    }

    function hideEplayerHolder(parent)
    {
        if(parent.id =="eplayerHolder" || parent.className =="eplayerHolder")
        {
            parent.style.display = "none";
        }
    }

    function showEplayerHolder(parent)
    {
        if(parent.id =="eplayerHolder" || parent.className =="eplayerHolder")
        {
            parent.style.display = "";
        }
    }

    function openRequestedPopup(path)
    {
        var title = "eplayerWindow"
        WindowObjectReference = window.open(path, title, WINDOW_FEATURES);

        if(!WindowObjectReference)
        {
            WindowObjectReference               = window.open('', title, WINDOW_FEATURES);
            WindowObjectReference.location.href = path;
        }

        return WindowObjectReference;
    }

    function alertStatus(e)
    {
        try
        {
            startCheckinOnView();

            if(!e.success )
            {
                var element     = document.createElement("video");
                var canPlayType = !!element.canPlayType;

                if(canPlayType)
                {
                    addHTML5Player();
                    currentPlayer.isEmbeded = true;
                }
                else
                {
                    currentPlayer.showFlashAndHtml5Warning();
                }

                isEmbedding = false;
            }
            else
            {
                currentPlayer.isEmbeded = true;
            }
        }
        catch(error)
        {
            //nothing to do
        }
    }

    function addCmsMockPlayer(width, height, autoPlay, mute, playerType)
    {
        var customSettings = {};

        if (width && height)
        {
            customSettings.width = width;
            customSettings.height = height;
        }

        addPlayer('', '', '', 'flashContent', autoPlay, mute, 'flashContent', playerType, customSettings);
    }

    function addCustomPlayer(p_playerUuid, p_channelUuid, p_videoUuid, p_width, p_height, p_divNameString, p_playerType, p_customSettings)
    {
        var customSettings = p_customSettings ? p_customSettings : {};

        customSettings.width  = p_width;
        customSettings.height = p_height;

        addPlayer(p_channelUuid, p_videoUuid, '', p_divNameString, null, null, p_playerUuid, p_playerType, customSettings);
    }

    function addResponsivePlayer(p_playerUuid, p_channelUuid, p_videoUuid, p_divNameString, p_playerType, p_customSettings)
    {
        var customSettings = p_customSettings ? p_customSettings : {};

        customSettings.resizeMode = true;

        addPlayer(p_channelUuid, p_videoUuid, '', p_divNameString, null, null, p_playerUuid, p_playerType, customSettings);
    }

    function addCmsPreviewPlayer(playerUuid, videoUuid, width, height, divNameString, playerType, xmlPath, p_customSettings)
    {
        var customSettings = p_customSettings ? p_customSettings : {};

        customSettings.width    = width;
        customSettings.height   = height;
        customSettings.xmlPath  = xmlPath;

        addPreviewPlayer('', videoUuid, '', divNameString, null, null, playerUuid, playerType, customSettings);
    }

    function addHTML5Player()
    {
        var div     = currentPlayer.getHtmlElement();
        var hash    = '#';

        for (var key in currentPlayer)
        {
            var value = currentPlayer[key];
            if(typeof(value) == "string" || typeof(value) == "number" || typeof(value) == "boolean")
            {
                hash += key + '=' + value + '&';
            }
        }

        var iframe = document.createElement("iframe");

        iframe.id               = currentPlayer.eplayerID;
        iframe.src              = currentPlayer.html5Path + hash;
        iframe.width            = currentPlayer.SWFWidth;
        iframe.height           = currentPlayer.SWFHeight;
        iframe.scrolling        = "no";
        iframe.frameBorder      = 0;
        iframe.style.visibility = 'visible';

        iframe.setAttribute("mozallowfullscreen"    , "");
        iframe.setAttribute("webkitallowfullscreen" , "");
        iframe.setAttribute("msallowfullscreen"     , "");
        iframe.setAttribute("allowfullscreen"       , "");

        div.parentNode.replaceChild(iframe, div);
    }

    function getFlashMovie(movieName)
    {
        var isIE = navigator.appName.indexOf("Microsoft") != -1;
        return (isIE) ? window[movieName] : document[movieName];
    }

    function getEplayerElement(p_eplayerID)
    {
        var flash = getFlashMovie( p_eplayerID);
        var frame = document.getElementById( p_eplayerID );

        if(flash)  return flash;
        if(frame)  return frame.contentWindow;

        return null;
    }

    function globalConfigLoaded(p_eplayerID, p_autoPlay, p_scrollToPlay )
    {
        var info = getPlayerInfo(p_eplayerID);

        if(info)
        {
            var auto

            info.isAutoplay     = p_autoPlay;
            info.isScrollToPlay = p_scrollToPlay;
            info.isConfigLoaded = true

            if(info.isScrollToPlay && !hasAutoplayPlayer())
            {
                startScrollToPlay();
            }
            else if(info.isAutoplay && !info.isScrollToPlay)
            {
                globalPause(p_eplayerID);
            }
        }

        isEmbedding = false;
    }

    function startScrollToPlay()
    {
        if(isEmbedding)
        {
            setTimeout(function()
            {
                startScrollToPlay();
            }, 1000);

            return;
        }

        if(!hasAutoplayPlayer())
        {
            checkAllEplayerOnView();
        }
    }

    function hasAutoplayPlayer()
    {
        for( var i = 0; i < window.ePlayers.length; i++ )
        {
            var player = window.ePlayers[i];

            if (player.isConfigLoaded && player.isAutoplay && !player.isScrollToPlay)
            {
                return true;
            }
        }

        return false;
    }

    function globalConfigError(p_eplayerID)
    {
        var info = getPlayerInfo(p_eplayerID);

        if(info)
        {
            info.isAutoplay     = false;
            info.isScrollToPlay = false;
            info.isConfigLoaded = true;
        }

        isEmbedding = false;
    }

    function globalPause( p_eplayerID, p_country )
    {
        for( var i = 0; i < window.ePlayers.length; i++ )
        {
            var ePlayer = window.ePlayers[i];

            if( typeof p_eplayerID != "undefined" && p_eplayerID != ePlayer.eplayerID)
            {

                var flash = getFlashMovie( ePlayer.eplayerID );
                if(flash)
                {
                    try
                    {
                        if(ePlayer.isConfigLoaded)
                        {
                            flash.globalPause();
                        }
                    }
                    catch(error)
                    {
                        //
                    }
                }

                else
                {
                    try
                    {
                        var frame = document.getElementById(p_eplayerID);
                        frame.contentWindow.postMessage("globalPause","*");
                    }
                    catch(error)
                    {
                        //
                    }
                }

            }
        }

    }

    function globalMute( p_eplayerID )
    {
        for( var i = 0; i < window.ePlayers.length; i++ )
        {
            var ePlayer = window.ePlayers[i];

            if( typeof p_eplayerID != "undefined" && ( p_eplayerID != ePlayer.eplayerID) )
            {
                var flash = getFlashMovie( ePlayer.eplayerID );
                if(flash)
                {
                    try
                    {
                        flash.globalMute();
                    }
                    catch( err )
                    {
                    }
                }
                else
                {
                    var frame = document.getElementById( ePlayer.eplayerID );

                    if(frame)
                    {
                        try {
                            //frame.contentWindow.globalMute();
                        }
                        catch( err )
                        {
                        }
                    }
                }
            }
        }
    }

    //Only HTML5 eplayer feature. function reach html5 eplayer functions directly
    function directVideoPlayback(p_eplayerID, data)
    {
        for( var i = 0; i < window.ePlayers.length; i++ )
        {
            var ePlayer = window.ePlayers[i];

            if(p_eplayerID == ePlayer.eplayerID )
            {
                var frame = document.getElementById( ePlayer.eplayerID );

                if(frame)
                {
                    try
                    {
                        data["p_type"] = "directVideoPlayback";
                        frame.contentWindow.directVideoPlayback(data);
                    }
                    catch( err )
                    {
                        console.log("error");
                    }
                }

                break;
            }
        }
    }

    function externalVideoPlayback(p_eplayerID,data)
    {
        for( var i = 0; i < window.ePlayers.length; i++ )
        {
            var ePlayer = window.ePlayers[i];

            if( typeof p_eplayerID != "undefined" && ( p_eplayerID != ePlayer.eplayerID) )
            {
                var flash = getFlashMovie( ePlayer.eplayerID );

                if(flash)
                {
                    try
                    {
                        flash.externalVideoPlayback(data);
                    }
                    catch( err )
                    {
                    }
                }
                else
                {
                    var frame = document.getElementById( ePlayer.eplayerID );

                    if(frame)
                    {
                        try
                        {
                            frame.contentWindow.externalVideoPlayback(data);
                        }
                        catch( err )
                        {
                        }
                    }
                }
            }
        }


    }

    // Handling the postMessage
    function ePlayer_message (event)
    {
        if( event.origin != "http://cdn-static.liverail.com" && event.data && !event.isHandledEplayerMessage && isEplayerMessage(event))
        {
            try
            {
                var message = JSON ? JSON.parse(event.data) : $.parseJSON(event.data);

                if( message.globalPause == true )
                {
                    var pID = typeof message.playerID == "undefined" ? "pause" : message.playerID;
                    globalPause( pID, message.country );
                }
                else if(message.addLogEntry == true && eplayerLogManager)
                {
                    eplayerLogManager.addLogEntry(message.eplayerID, message.type, message.subtype, message.params)
                }
                else if(message.toggleFullSize === "true" && message.eplayerID)
                {
                    event.isHandledEplayerMessage = true;
                    toggleFullSize(message.eplayerID);
                }
            }
            catch ( err )
            {
                //nothing is written to console
            }
        }
    }

    function isEplayerMessage (event)
    {
        try
        {
            if(event && event.source)
            {
                for( var i = 0; i < window.ePlayers.length; i++ )
                {
                    var eplayer =  window.ePlayers[i];

                    if(eplayer.getHtmlElement().contentWindow == event.source)
                    {
                        return true;
                    }
                }
            }
        }
        catch ( err )
        {
            //nothing is written to console
        }

        return false;
    }

    // check the player visibility
    function checkAllEplayerOnView(){
        for( var i = 0; i < window.ePlayers.length; i++ )
        {
            var eplayer =  window.ePlayers[i];

            if(eplayer.eplayerID && eplayer.isConfigLoaded)
            {
                var onView = isPlayerVisible(eplayer.eplayerID);

                try
                {
                    var flashMovie = getFlashMovie(eplayer.eplayerID);

                    if(eplayer.isScrollToPlay){

                        flashMovie.playerVisibilityChanged(onView);

                        var isPaused = flashMovie.isPaused();

                        if(onView && !isPaused)
                        {
                            globalPause(eplayer.eplayerID);
                        }
                    }

                }
                catch(e){};

                eplayer.onView = onView;
            }
        }
    }
    function isPlayerVisible(playerID){
        var playerInstance = getFlashMovie(playerID);

        var isOnView = false;
        try{
            var checkFullPlayer = false;
            var checkOnlyVerticaly = false;

            var playerDims = getPlayerDimensions(playerInstance);
            var playerXOffset = playerDims.x;
            var playerYOffset = playerDims.y;
            var playerWidth = playerDims.width ;
            var playerHeight = playerDims.height

            var windowDims = getScreenDimensions();
            var windowHeight = windowDims.height;
            var windowWidth = windowDims.width;
            var windowXOffset = windowDims.x;
            var windowYOffset = windowDims.y;


            var playerIsFullOnViewX  = ((playerXOffset - windowXOffset > 0) && (playerXOffset - windowXOffset < windowWidth  - playerWidth)) ? true : false;
            var playerIsPartlyOnViewX = ((playerXOffset - windowXOffset > 0 - playerWidth) && (playerXOffset - windowXOffset < windowWidth)) ? true : false;
            var playerIsFullOnViewY = ((playerYOffset - windowYOffset > 0) && (playerYOffset - windowYOffset < windowHeight  - playerHeight)) ? true : false;
            var playerIsPartlyOnViewY = ((playerYOffset - windowYOffset > 0 - playerHeight/2) && (playerYOffset - windowYOffset < windowHeight-playerHeight/2)) ? true : false;

            if(checkFullPlayer && !checkOnlyVerticaly)
                isOnView = (playerIsFullOnViewX && playerIsFullOnViewY) ? true : false;
            else if(checkFullPlayer && checkOnlyVerticaly)
                isOnView = (playerIsFullOnViewY) ? true : false;
            else if(!checkFullPlayer && !checkOnlyVerticaly)
                isOnView = (playerIsPartlyOnViewX && playerIsPartlyOnViewY) ? true : false;
            else if(!checkFullPlayer && checkOnlyVerticaly)
                isOnView = (playerIsPartlyOnViewY) ? true : false;
        }
        catch(err){}

        return isOnView;
    }

    function getPlayerDimensions(playerInstance)
    {
        var playerX       = playerInstance.offsetLeft;
        var playerY       = playerInstance.offsetTop;
        var playerWidth   = playerInstance.offsetWidth;
        var playerHeight  = playerInstance.offsetHeight;

        while(playerInstance.offsetParent)
        {
            playerInstance       = playerInstance.offsetParent;
            playerY             += playerInstance.offsetTop;
            playerX             += playerInstance.offsetLeft;
        }

        return {width: playerWidth, height: playerHeight,x:playerX, y:playerY};
    }

    function getScreenDimensions(){

        var windowHeight;
        var windowWidth;

        if (document.body && document.body.offsetWidth) {
            windowWidth = document.body.offsetWidth;
            windowHeight = document.body.offsetHeight;
        }
        if (document.compatMode=='CSS1Compat' &&
            document.documentElement &&
            document.documentElement.offsetWidth ) {
            windowWidth = document.documentElement.offsetWidth;
            windowHeight = document.documentElement.offsetHeight;
        }
        if (window.innerWidth && window.innerHeight) {
            windowWidth = window.innerWidth;
            windowHeight = window.innerHeight;
        }

        var windowXOffset = 0;
        var windowYOffset = 0;

        if(window.scrollY || window.scrollX){
            windowXOffset = window.scrollX;
            windowYOffset = window.scrollY;
            return {width: windowWidth, height: windowHeight, x: windowXOffset, y: windowYOffset};
        }
        if(document.documentElement.scrollTop || document.documentElement.scrollLeft){
            windowXOffset = document.documentElement.scrollLeft;
            windowYOffset =document.documentElement.scrollTop;
            return {width: windowWidth, height: windowHeight, x: windowXOffset, y: windowYOffset};
        }
        if(window.pageYOffset || window.pageXOffset){
            windowXOffset = window.pageXOffset;
            windowYOffset = window.pageYOffset;
            return {width: windowWidth, height: windowHeight, x: windowXOffset, y: windowYOffset};
        }
        if(document.body.scrollTop || document.body.scrollLeft){
            windowXOffset = document.body.scrollLeft;
            windowYOffset = document.body.scrollTop;
        }

        return {width: windowWidth, height: windowHeight, x: windowXOffset, y: windowYOffset};
    }

    function startCheckinOnView(){
        if (window.attachEvent)
        {
            window.detachEvent("onscroll",checkAllEplayerOnView);
            window.detachEvent("onresize",checkAllEplayerOnView);
            window.attachEvent("onscroll",checkAllEplayerOnView);
            window.attachEvent("onresize",checkAllEplayerOnView);
        }
        else if (window.addEventListener)
        {
            window.removeEventListener("scroll",checkAllEplayerOnView);
            window.removeEventListener("resize",checkAllEplayerOnView);
            window.addEventListener("scroll",checkAllEplayerOnView);
            window.addEventListener("resize",checkAllEplayerOnView);
        }
    }

    function trace(message){
        if(window.console)console.log(message);
    }

    function isCustomPlayer(playerType)
    {
        var isCustomPlayer = false;

        if(playerType)
        {
            try
            {
                var index = Number(playerType.toLowerCase().replace("eplayer", ""));

                isCustomPlayer = RESIZABLE_PLAYERS[index - 1];
            }
            catch(error)
            {
                //nothing to do
            }
        }

        return isCustomPlayer;
    }

    function onResizeTimer()
    {
        for( var i = 0; i < window.ePlayers.length; i++ )
        {
            var info = window.ePlayers[i];

            if(info && info.resizeMode === true && info.isEmbeded === true && !info.isFullSizeOn)
            {
                info.resizeToParent();
            }
            else if(info && info.isEmbeded === true && info.isFullSizeOnError)
            {
                info.setFullSizeOn();
            }
            else if(info && info.isEmbeded === true && info.isFullSizeOffError)
            {
                info.setFullSizeOff();
            }
        }

        if(!window.isResizeListenerAvailable && onWindowResized)
        {
            onWindowResized();
        }
    }

    function getPlayerInfo(eplayerID)
    {
        for( var i = 0; i < window.ePlayers.length; i++ )
        {
            if(window.ePlayers[i].eplayerID == eplayerID)
            {
                return window.ePlayers[i];
            }
        }

        return {};
    }

    function getUserLocation()
    {
        return userLocation;
    }

    function loadLogSystem()
    {
        var hash            = getUrlVars();
        var logBasePath    = hash[QUERY_PARAM_LOGPATH ] ? hash[QUERY_PARAM_LOGPATH]: PATH_LOGSYSTEM;
        var debugMode      = hash[QUERY_PARAM_DEBUG] === "true";

        if(debugMode && !window.isLogSystemLoaded)
        {
            window.isLogSystemLoaded = true;

            var script = document.createElement('script');

            script.setAttribute("type"      ,"text/javascript");
            script.setAttribute("src"       , logBasePath + "performgroup_logging.js");
            script.setAttribute("class"     , "dinamicScript");
            script.setAttribute("id"        , "eplayerLogging");
            script.setAttribute("basePath"  , logBasePath);

            script.loader = this;

            document.getElementsByTagName("head")[0].appendChild(script);
        }
    }

    function destroyEplayer(eplayerID)
    {
        removeEplayer(eplayerID);

        var eplayer = document.getElementById(eplayerID );

        if(eplayer && eplayer.parentNode)
        {
            hideEplayerHolder(eplayer.parentNode);
            eplayer.parentNode.removeChild(eplayer);
        }
    }

    function removeEplayer(eplayerID)
    {
        var info    = getPlayerInfo(eplayerID);

        if(info)
        {
            var newEPlayers = [];

            for( var i = 0; i < window.ePlayers.length; i++ )
            {
                if(window.ePlayers[i].eplayerID != eplayerID)
                {
                    newEPlayers.push(window.ePlayers[i]);
                }
            }

            window.ePlayers = newEPlayers;
        }
    }

    function destroyAllEplayer()
    {
        for( var i = 0; i < window.ePlayers.length; i++ )
        {
            destroyEplayer(window.ePlayers[i].eplayerID);
        }

        window.ePlayers = [];
    }

    function clearResizeInterval()
    {
        if(window.eplayerResizeTimerID)
        {
            clearInterval(window.eplayerResizeTimerID);

            window.eplayerResizeTimerID = null;
        }
    }

    function startResizeInterval()
    {
        window.eplayerResizeTimerID = setInterval(onResizeTimer, 300);
    }

    function toggleFullSize(eplayerID)
    {
        var info = getPlayerInfo(eplayerID);

        if(info)
        {
            info.toggleFullSize();
        }
    }

    function addWindowResizeListener()
    {
        if(window.attachEvent)
        {
            window.attachEvent("resize", onWindowResized);
        }
        else if(window.addEventListener)
        {
            window.addEventListener("resize", onWindowResized);
        }
        else
        {
            window.isResizeListenerAvailable = false;
        }
    }

    function removeWindowResizeListener()
    {
        if(window.detachEvent)
        {
            window.detachEvent("resize", onWindowResized);
        }
        else if(window.removeEventListener)
        {
            window.removeEventListener("resize", onWindowResized);
        }
    }

    function onWindowResized()
    {
        for( var i = 0; i < window.ePlayers.length; i++ )
        {
            var info = window.ePlayers[i];

            if(info && info.isEmbeded === true && info.isFullSizeOn)
            {
                info.resizeToWindow();
            }
        }
    }

    function addMessageListener()
    {
        if (window.attachEvent)
        {
            window.attachEvent('onmessage', ePlayer_message);
        }
        else if (window.addEventListener)
        {
            window.addEventListener('message', ePlayer_message, false);
        }
    }

    function removeMessageListener()
    {
        if (window.detachEvent)
        {
            window.detachEvent('onmessage', ePlayer_message);
        }
        else if (window.removeEventListener)
        {
            window.removeEventListener('message', ePlayer_message, false);
        }
    }

    function checkPlayerCount()
    {
        if(HEIGHTS_BANNER        .length != PLAYER_COUNT) throw "HEIGHTS_BANNER has no correct length.";
        if(HEIGHTS_CAROUSEL      .length != PLAYER_COUNT) throw "HEIGHTS_CAROUSEL has no correct length.";
        if(HEIGHTS_CONTROL_BAR   .length != PLAYER_COUNT) throw "HEIGHTS_CONTROL_BAR has no correct length.";
        if(RESIZABLE_PLAYERS     .length != PLAYER_COUNT) throw "RESIZABLE_PLAYERS has no correct length.";
        if(EPLAYER_WIDTHS        .length != PLAYER_COUNT) throw "EPLAYER_WIDTHS has no correct length.";
        if(EPLAYER_HEIGHTS       .length != PLAYER_COUNT) throw "EPLAYER_HEIGHTS has no correct length.";
    }

    checkPlayerCount();
    clearResizeInterval();
    startResizeInterval();
    removeMessageListener();
    addMessageListener();
    removeWindowResizeListener();
    addWindowResizeListener();
    loadUserLocationScript();

    // public methods
    window.directVideoPlayback          = directVideoPlayback;
    window.userLocationServerCallback   = userLocationServerCallback;
    window.getUserLocation              = getUserLocation;
    window.externalVideoPlayback        = externalVideoPlayback;
    window.addPlayer                    = addPlayer;
    window.addPreviewPlayer             = addPreviewPlayer;
    window.openRequestedPopup           = openRequestedPopup;
    window.alertStatus                  = alertStatus;
    window.addCmsMockPlayer             = addCmsMockPlayer;
    window.addCustomPlayer              = addCustomPlayer;
    window.addResponsivePlayer          = addResponsivePlayer;
    window.addCmsPreviewPlayer          = addCmsPreviewPlayer;
    window.globalPause                  = globalPause;
    window.isPlayerVisible              = isPlayerVisible;
    window.isCustomPlayer               = isCustomPlayer;
    window.destroyEplayer               = destroyEplayer;
    window.destroyAllEplayer            = destroyAllEplayer;
    window.toggleFullSize               = toggleFullSize;
    window.globalConfigLoaded           = globalConfigLoaded;
    window.globalConfigError            = globalConfigError;

}(this));