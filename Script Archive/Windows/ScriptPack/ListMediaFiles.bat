@TITLE Lists Media Files
@ECHO OFF
ECHO --------------------------------------------------
ECHO This script must be run as Administrator (SYSTEM32).
ECHO Please ensure that the script is running as SYSTEM32.
ECHO --------------------------------------------------

PAUSE

ECHO Scanning for media files (Will take time)...
REM the result file is allmedia.txt

md scan

REM dam,gam,rom,sav,nex,cda, ivf,wax,wm, wmd, wvx, wmp,wmx, wmz,wms, m1v,
REM mpe, mp2v*,mpv2, rmi, snd, m3u, ac3,wpl,pic

dir \*.dam /s > .\scan\001.txt
dir \*.gam /s > .\scan\002.txt
dir \*.rom /s > .\scan\003.txt
dir \*.sav /s > .\scan\004.txt
dir \*.nex /s > .\scan\005.txt
dir \*.cda /s > .\scan\006.txt
dir \*.ivf /s > .\scan\007.txt
dir \*.wax /s > .\scan\008.txt
dir \*.wm /s > .\scan\009.txt
dir \*.wmd /s > .\scan\010.txt
dir \*.wvx /s > .\scan\011.txt
dir \*.wmp /s > .\scan\012.txt
dir \*.wmx /s > .\scan\013.txt
dir \*.wmz /s > .\scan\014.txt
dir \*.wms /s > .\scan\015.txt
dir \*.m1v /s > .\scan\016.txt
dir \*.mpe /s > .\scan\017.txt
dir \*.mp2v? /s > .\scan\018.txt
dir \*.mpv2 /s > .\scan\019.txt
dir \*.rmi /s > .\scan\020.txt
dir \*.snd /s > .\scan\021.txt
dir \*.m3u /s > .\scan\022.txt
dir \*.wpl /s > .\scan\023.txt
dir \*.ac3 /s > .\scan\024.txt
dir \*.pic /s > .\scan\025.txt



REM Audio:
REM 3ga,aac,aif,aifc,aiff,amr,ape,asx,au,aup,caf,flac,gsm,iff,kar,koz,m3u8,m4a,m4p,m4r,mid,
REM midi,mmf,mp2,mp3,mpa,mpc,mpga,ogg,oma,opus,qcp,ra,ram,rta,wav,wma,xspf


dir \*.3ga /s > .\scan\029.txt
dir \*.aac /s > .\scan\030.txt
dir \*.aif /s > .\scan\031.txt
dir \*.aifc /s > .\scan\032.txt
dir \*.aiff /s > .\scan\033.txt
dir \*.amr /s > .\scan\034.txt
dir \*.ape /s > .\scan\035.txt
dir \*.asx /s > .\scan\036.txt
dir \*.au /s > .\scan\037.txt
dir \*.aup /s > .\scan\038.txt
dir \*.caf /s > .\scan\039.txt
dir \*.flac /s > .\scan\040.txt
dir \*.gsm /s > .\scan\041.txt
dir \*.iff /s > .\scan\042.txt

dir \*.kar /s > .\scan\043.txt
dir \*.koz /s > .\scan\044.txt
dir \*.m3u8 /s > .\scan\045.txt
dir \*.m4a /s > .\scan\046.txt
dir \*.m4p /s > .\scan\047.txt
dir \*.m4r /s > .\scan\048.txt
dir \*.mid /s > .\scan\049.txt
dir \*.midi /s > .\scan\050.txt
dir \*.mmf /s > .\scan\051.txt
dir \*.mp2 /s > .\scan\052.txt
dir \*.mp3 /s > .\scan\053.txt
dir \*.mpa /s > .\scan\054.txt
dir \*.mpc /s > .\scan\055.txt
dir \*.mpga /s > .\scan\056.txt

dir \*.ogg /s > .\scan\057.txt
dir \*.oma /s > .\scan\058.txt
dir \*.opus /s > .\scan\059.txt
dir \*.qcp /s > .\scan\060.txt
dir \*.ra /s > .\scan\061.txt
dir \*.ram /s > .\scan\062.txt
dir \*.rta /s > .\scan\0621.txt
dir \*.wav /s > .\scan\063.txt
dir \*.wma /s > .\scan\064.txt
dir \*.xspf /s > .\scan\065.txt

REM Video:
REM 264,3g2,3gp,3gpp,amv,arf,asf,avi,ced,cpi,dav,divx,dvsd,f4v,flv,h264,ifo,m2ts,m4v,mkv,
REM mod,mov,mp4,mpeg,mpg,mswmm,mts,mxf,ogv,pds,qt,rm,srt,swf,ts,veg,vep,vob,vpj,
REM webm,wlmp,wmv

dir \*.264 /s > .\scan\066.txt
dir \*.3g2 /s > .\scan\067.txt
dir \*.3gp /s > .\scan\0671.txt
dir \*.3gpp /s > .\scan\068.txt
dir \*.amv /s > .\scan\069.txt
dir \*.arf /s > .\scan\070.txt
dir \*.asf /s > .\scan\071.txt
dir \*.avi /s > .\scan\072.txt
dir \*.ced /s > .\scan\073.txt
dir \*.cpi /s > .\scan\074.txt
dir \*.dav /s > .\scan\075.txt
dir \*.divx /s > .\scan\076.txt
dir \*.dvsd /s > .\scan\077.txt
dir \*.f4v /s > .\scan\078.txt
dir \*.flv /s > .\scan\079.txt

dir \*.h264 /s > .\scan\080.txt
dir \*.ifo /s > .\scan\081.txt
dir \*.m2ts /s > .\scan\082.txt
dir \*.m4v /s > .\scan\083.txt
dir \*.mkv /s > .\scan\084.txt
dir \*.mod /s > .\scan\085.txt
dir \*.mov /s > .\scan\086.txt
dir \*.mp4 /s > .\scan\087.txt
dir \*.mpeg /s > .\scan\088.txt
dir \*.mpg /s > .\scan\089.txt
dir \*.mswmm /s > .\scan\090.txt
dir \*.mts /s > .\scan\091.txt
dir \*.mxf /s > .\scan\092.txt
dir \*.ogv /s > .\scan\093.txt


dir \*.pds /s > .\scan\094.txt
dir \*.qt /s > .\scan\095.txt
dir \*.rm /s > .\scan\096.txt
dir \*.srt /s > .\scan\097.txt
dir \*.swf /s > .\scan\098.txt
dir \*.ts /s > .\scan\099.txt
dir \*.veg /s > .\scan\100.txt
dir \*.vep /s > .\scan\101.txt
dir \*.vob /s > .\scan\102.txt
dir \*.vpj /s > .\scan\103.txt

dir \*.webm /s > .\scan\104.txt
dir \*.wlmp /s > .\scan\105.txt
dir \*.wmv /s > .\scan\106.txt

REM Image:
REM art,arw,bmp,cr2,crw,dcm,dds,djvu,dmg,dng,exr,fpx,gif,hdr,ico,ithmb,jp2,jpeg,jpg,kdc,
REM nef,nrw,orf,pcd,pct,pcx,pef,pict,png,psd,pspimage,sfw,tga,thm,tif,tiff,wbmp,webp,xcf,yuv
REM ai,cdr,emz,eps,mix,odg,pd,svg,vsd,wmf,wpg


dir \*.art /s > .\scan\107.txt
dir \*.arw /s > .\scan\108.txt
dir \*.bmp /s > .\scan\109.txt
dir \*.cr2 /s > .\scan\110.txt
dir \*.crw /s > .\scan\111.txt
dir \*.dcm /s > .\scan\112.txt
dir \*.dds /s > .\scan\113.txt
dir \*.djvu /s > .\scan\114.txt
dir \*.dmg /s > .\scan\115.txt
dir \*.dng /s > .\scan\116.txt
dir \*.exr /s > .\scan\117.txt
dir \*.fpx /s > .\scan\118.txt
dir \*.gif /s > .\scan\119.txt
dir \*.hdr /s > .\scan\120.txt

dir \*.ico /s > .\scan\121.txt
dir \*.ithmb /s > .\scan\122.txt
dir \*.jp2 /s > .\scan\123.txt
dir \*.jpeg /s > .\scan\124.txt
dir \*.jpg /s > .\scan\125.txt
dir \*.kdc /s > .\scan\126.txt
dir \*.nef /s > .\scan\127.txt
dir \*.nrw /s > .\scan\128.txt
dir \*.orf /s > .\scan\129.txt
dir \*.pcd /s > .\scan\130.txt
dir \*.pct /s > .\scan\131.txt
dir \*.pcx /s > .\scan\132.txt
dir \*.pef /s > .\scan\133.txt
dir \*.pict /s > .\scan\134.txt


dir \*.png /s > .\scan\135.txt
dir \*.psd /s > .\scan\136.txt
dir \*.pspimage /s > .\scan\137.txt
dir \*.sfw /s > .\scan\138.txt
dir \*.tga /s > .\scan\139.txt
dir \*.thm /s > .\scan\140.txt
dir \*.tif /s > .\scan\141.txt
dir \*.tiff /s > .\scan\142.txt
dir \*.wbmp /s > .\scan\143.txt
dir \*.webp /s > .\scan\144.txt
dir \*.xcf /s > .\scan\145.txt
dir \*.yuv /s > .\scan\146.txt
dir \*.ai /s > .\scan\147.txt
dir \*.cdr /s > .\scan\148.txt

dir \*.emz /s > .\scan\149.txt
dir \*.eps /s > .\scan\150.txt
dir \*.mix /s > .\scan\151.txt
dir \*.odg /s > .\scan\152.txt
dir \*.pd /s > .\scan\153.txt
dir \*.svg /s > .\scan\154.txt
dir \*.vsd /s > .\scan\155.txt
dir \*.wmf /s > .\scan\156.txt
dir \*.wpg /s > .\scan\157.txt

copy .\scan\*.txt allmedia.txt

del scan /q
rd scan

Listing all
ECHO --------------------------------------------------
ECHO The script has finished executing. Please check for any possible errors now.
PAUSE

