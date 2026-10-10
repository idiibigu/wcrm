# تجهيز WCRM by Idiibi على VPS

هذه الحزمة تستهدف Ubuntu 22.04 أو 24.04 على VPS بصلاحية `sudo`. يلزم نطاق DNS موجّه إلى عنوان السيرفر؛ لا تتضمن الحزمة شهادة SSL أو بيانات دخول لخادم الاستضافة.

## 1. فكّ الحزمة

ارفع `whatscrm-vps-deploy.zip` إلى السيرفر، ثم:

```bash
sudo mkdir -p /opt/whatscrm
sudo unzip whatscrm-vps-deploy.zip -d /tmp/whatscrm-unpack
sudo cp -a /tmp/whatscrm-unpack/WhatsCRM-VPS/. /opt/whatscrm/
```

## 2. تثبيت متطلبات النظام

يحتاج التطبيق Node.js 20 أو أحدث؛ Node.js 22 هو الخيار الموصى به. ثبّت Node.js 22 من مصدر موثوق، إضافة إلى MariaDB وNginx وFFmpeg:

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt-get update
sudo apt-get install -y nodejs nginx mariadb-server ffmpeg unzip
node --version
```

لا تتابع ما لم يكن Node.js بالإصدار 22. وثائق التثبيت الرسمية: <https://github.com/nodesource/distributions>.

## 3. إعداد قاعدة بيانات جديدة

أنشئ كلمة مرور عشوائية واحفظها مؤقتًا في الطرفية:

```bash
DBPASS="$(openssl rand -hex 32)"
JWTKEY="$(openssl rand -hex 48)"
```

أنشئ قاعدة ومستخدمًا بصلاحيات محدودة على السيرفر المحلي فقط:

```bash
sudo mariadb -e "CREATE DATABASE whatscrm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; CREATE USER 'whatscrm_app'@'127.0.0.1' IDENTIFIED BY '${DBPASS}'; GRANT ALL PRIVILEGES ON whatscrm.* TO 'whatscrm_app'@'127.0.0.1'; FLUSH PRIVILEGES;"
sudo mariadb whatscrm < /opt/whatscrm/database/import.sql
```

ملف SQL المرفق يحتوي على الجداول وحساب مدير جديد فقط؛ حُذفت منه حسابات المستخدمين والموظفين والبيانات التجريبية. لا تستورد هذا المخطط فوق قاعدة بيانات تحتوي على بيانات تريد الاحتفاظ بها.

## 4. إعداد أسرار التطبيق

أنشئ مستخدم خدمة غير تفاعلي، ومجلدًا خاصًا لإعدادات الخدمة:

```bash
sudo useradd --system --home /opt/whatscrm --shell /usr/sbin/nologin whatscrm
sudo install -d -o root -g whatscrm -m 750 /etc/whatscrm
sudo tee /etc/whatscrm/whatscrm.env > /dev/null <<EOF
PORT=3010
DBHOST=127.0.0.1
DBNAME=whatscrm
DBUSER=whatscrm_app
DBPASS=${DBPASS}
DBPORT=3306
JWTKEY=${JWTKEY}
FRONTENDURI=https://YOUR_DOMAIN
BACKURI=https://YOUR_DOMAIN
DOMAIN=YOUR_DOMAIN
STRIPE_LANG=en
NODE_ENV=production
EOF
sudo chown root:whatscrm /etc/whatscrm/whatscrm.env
sudo chmod 640 /etc/whatscrm/whatscrm.env
unset DBPASS JWTKEY
```

حرّر `/etc/whatscrm/whatscrm.env` واستبدل `YOUR_DOMAIN` باسم نطاقك الفعلي دون `https://` إضافية أو مسار، مثل `crm.example.com`. اجعل `FRONTENDURI` و`BACKURI` يطابقان العنوان العام الذي سيستخدمه التطبيق. لا ترفع ملف أسرار حقيقيًا إلى موقع عام أو مستودع.

## 5. تثبيت اعتمادات Node.js وتشغيل الخدمة

```bash
sudo chown -R whatscrm:www-data /opt/whatscrm
cd /opt/whatscrm/server
sudo -u whatscrm npm ci --omit=dev
sudo cp /opt/whatscrm/deploy/whatscrm.service /etc/systemd/system/whatscrm.service
sudo systemctl daemon-reload
sudo systemctl enable --now whatscrm
sudo systemctl status whatscrm --no-pager
```

راجع السجل إذا لم تعمل الخدمة:

```bash
sudo journalctl -u whatscrm -n 100 --no-pager
```

## 6. إعداد Nginx والنطاق

تأكد أولًا أن سجلات DNS من النوع `A` للنطاق و`www` تشير إلى عنوان VPS. ثم:

```bash
sudo cp /opt/whatscrm/deploy/nginx-whatscrm.conf /etc/nginx/sites-available/whatscrm
sudo nano /etc/nginx/sites-available/whatscrm
```

استبدل كل `YOUR_DOMAIN` في الملف بنطاقك، ثم فعّل الموقع وافتح HTTP وHTTPS في الجدار الناري:

```bash
sudo ln -s /etc/nginx/sites-available/whatscrm /etc/nginx/sites-enabled/whatscrm
sudo nginx -t
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo systemctl reload nginx
```

بعد توجيه DNS ونجاح اختبار Nginx، فعّل HTTPS:

```bash
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d YOUR_DOMAIN -d www.YOUR_DOMAIN
```

استخدم أسماء النطاقات نفسها في أمر Certbot وملف إعداد Nginx. إذا لم يكن لديك نطاق `www`، احذفه من إعداد Nginx ومن الأمر.

## 7. الدخول والتحقق

- صفحة الإدارة: `https://YOUR_DOMAIN/admin`
- البريد الابتدائي: `admin@admin.com`
- كلمة مرور المدير الابتدائية: الكلمة التي زُوّدت بها مع ملف الحزمة. غيّرها مباشرة بعد أول تسجيل دخول.
- تحقق من أن الصفحة الرئيسية وطلب تسجيل الدخول يعملان، ثم أكمل إعدادات مزودي الخدمات والتكاملات من لوحة الإدارة. ربط WhatsApp يتطلب مسح رمز QR من الواجهة.

لا تترك بيانات الدخول الابتدائية كما هي؛ غيّر كلمة المرور قبل مشاركة النطاق أو فتح التسجيل للمستخدمين.

## ملفات يجب الحفاظ عليها والنسخ الاحتياطي لها

يحفظ التطبيق ملفات الجلسات والوسائط على القرص. احتفظ بنسخة احتياطية من قاعدة البيانات ومن هذه المسارات عند وجودها:

- `/opt/whatscrm/server/sessions`
- `/opt/whatscrm/server/client/public/media`
- `/opt/whatscrm/server/client/public/meta-media`
- `/opt/whatscrm/server/middlewares/license.json`

مثال لنسخة SQL احتياطية باستخدام حساب MariaDB الإداري المحلي:

```bash
sudo mariadb-dump --single-transaction whatscrm > /root/whatscrm-backup.sql
```

لا تفتح منفذ MySQL `3306` للإنترنت. يُستخدم `127.0.0.1` للاتصال المحلي.

## اعتماديات Google والملفات الخاصة

استُبعدت من حزمة النشر ملفات خدمة Google الخاصة التي كانت موجودة داخل مجلد
الوسائط العامة. إذا سبق نشر هذه النسخة على الإنترنت، ألغِ مفاتيح الخدمة القديمة
وأنشئ مفاتيح جديدة من Google Cloud قبل تفعيل التكامل. لا ترفع أو تخزّن مفتاحًا
خاصًا داخل `client/public` أو أي مسار يقدّمه Nginx أو Express مباشرة.
