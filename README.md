# Shartflix

Nodelabs Software Case

## Getting Started

Shartflix, kullanıcıların film içeriklerini keşfedebileceği, favorilere ekleyebileceği ve profil yönetimi yapabileceği bir Flutter uygulamasıdır.

### Features

- Kullanıcı kaydı ve giriş
- Profil fotoğrafı yükleme
- Film listesini dikey kaydırmalı şekilde görüntüleme
- Favori film ekleme/çıkarma
- Profil ve favori film yönetimi

### Screens

#### 1. Splash Screen
![Splash Screen](<img width="1440" height="2560" alt="SplashScreen" src="https://github.com/user-attachments/assets/25624deb-0a0b-4294-9bfc-1b10fc2f852c" />)
- Uygulama açıldığında gösterilir
- 2 saniye sonra login ekranına yönlendirir
- Uygulama logosu merkezde yer alır
- Arka plan radial gradient ile renklendirilmiştir

---

#### 2. Login Screen
![Login Screen](<img width="1440" height="2560" alt="LoginScreen" src="https://github.com/user-attachments/assets/6fe2801a-0edd-443f-b9a1-fbfa25e9430c" />)
- E-posta ve şifre alanları
- Şifre göster/gizle özelliği
- “Şifremi Unuttum” ve sosyal giriş butonları
- Başarılı giriş → Profile Photo Screen’e yönlendirme

---

#### 3. Register Screen
![Register Screen](<img width="1440" height="2560" alt="RegisterScreen" src="https://github.com/user-attachments/assets/42548c4e-0a23-4cb0-91ea-c7a535debdb6" />
)
- Ad Soyad, E-posta, Şifre ve Şifre Tekrar alanları
- Hatalı girişlerde uyarı mesajı gösterir
- Kayıt başarılı → Login Screen’e yönlendirme

---

#### 4. Profile Photo Screen
![Profile Photo Screen](<img width="1440" height="2560" alt="EditProfile" src="https://github.com/user-attachments/assets/2adc11ec-1d02-4a75-b92e-8381b155c853" />
)
- Kullanıcı profil fotoğrafını yükleyebilir veya atlayabilir
- Fotoğraf seçme ve yükleme özelliği
- “Devam Et” ve “Atla” butonları ile ilerleme

---

#### 5. Home Screen
![Home Screen](<img width="1440" height="2560" alt="HomeScreen" src="https://github.com/user-attachments/assets/7dadc03f-7d5e-4958-a8ff-bcd560063b0d" />
)
- Film listesini dikey kaydırmalı `PageView` ile gösterir
- Film posterleri ve açıklamaları
- Favori ekleme/çıkarma butonu
- Alt navbar ile Home ve Profile sayfasına geçiş

---

#### 6. Profile Screen
![Profile Screen](<img width="1440" height="2560" alt="ProfileScreen" src="https://github.com/user-attachments/assets/166c0e18-f7ae-43a3-9532-ece392c4bda1" />
)
- Kullanıcı bilgilerini gösterir (isim, ID, profil fotoğrafı)
- Favori filmler grid şeklinde görüntülenir
- Profil fotoğrafını ekleme veya değiştirme
- Alt navbar ile Home ve Profile sayfasına geçiş

---

### Installation

1. Flutter SDK’yı bilgisayarınıza kurun
2. Depoyu klonlayın:
```bash
git clone <repo-link>
