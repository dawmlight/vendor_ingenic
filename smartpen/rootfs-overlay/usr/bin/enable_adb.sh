cd "$(dirname $0)"

enable_flag=0
for i in $@; do
  if [ "$i" = "true" ]; then
    enable_flag=1
  fi
done

cur="$(getprop user.usb.config)"
echo "cur:$cur"
if [ "$enable_flag" = "1" ]; then
  echo "enable>>>>>>>>>"
  if [ $cur != "adb" ]; then
    echo "enable>>>>>>>>> set"
    setprop user.usb.config adb
  else
    echo "enable>>>>>>>>> not change"
  fi
else
  echo "disable>>>>>>>>>"
  setprop user.usb.config mtp
fi

 
