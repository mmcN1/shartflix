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

<table>
  <tr>
    <td>
      <b>1. Splash Screen</b><br>
      <img src="https://github.com/user-attachments/assets/25624deb-0a0b-4294-9bfc-1b10fc2f852c" width="200"/>
    </td>
    <td>
      - Uygulama açıldığında gösterilir<br>
      - 2 saniye sonra login ekranına yönlendirir<br>
      - Uygulama logosu merkezde yer alır<br>
      - Arka plan radial gradient ile renklendirilmiştir
    </td>
  </tr>
  <tr><td colspan="2"><hr></td></tr>
  
  <tr>
    <td>
      <b>2. Login Screen</b><br>
      <img src="https://github.com/user-attachments/assets/6fe2801a-0edd-443f-b9a1-fbfa25e9430c" width="200"/>
    </td>
    <td>
      - E-posta ve şifre alanları<br>
      - Şifre göster/gizle özelliği<br>
      - “Şifremi Unuttum” ve sosyal giriş butonları<br>
      - Başarılı giriş → Profile Photo Screen’e yönlendirme
    </td>
  </tr>
  <tr><td colspan="2"><hr></td></tr>
  
  <tr>
    <td>
      <b>3. Register Screen</b><br>
      <img src="https://github.com/user-attachments/assets/42548c4e-0a23-4cb0-91ea-c7a535debdb6" width="200"/>
    </td>
    <td>
      - Ad Soyad, E-posta, Şifre ve Şifre Tekrar alanları<br>
      - Hatalı girişlerde uyarı mesajı gösterir<br>
      - Kayıt başarılı → Login Screen’e yönlendirme
    </td>
  </tr>
  <tr><td colspan="2"><hr></td></tr>

  <tr>
    <td>
      <b>4. Profile Photo Screen</b><br>
      <img src="https://github.com/user-attachments/assets/2adc11ec-1d02-4a75-b92e-8381b155c853" width="200"/>
    </td>
    <td>
      - Kullanıcı profil fotoğrafını yükleyebilir veya atlayabilir<br>
      - Fotoğraf seçme ve yükleme özelliği<br>
      - “Devam Et” ve “Atla” butonları ile ilerleme
    </td>
  </tr>
  <tr><td colspan="2"><hr></td></tr>

  <tr>
    <td>
      <b>5. Home Screen</b><br>
      <img src="https://github.com/user-attachments/assets/7dadc03f-7d5e-4958-a8ff-bcd560063b0d" width="200"/>
    </td>
    <td>
      - Film listesini dikey kaydırmalı `PageView` ile gösterir<br>
      - Film posterleri ve açıklamaları<br>
      - Favori ekleme/çıkarma butonu<br>
      - Alt navbar ile Home ve Profile sayfasına geçiş
    </td>
  </tr>
  <tr><td colspan="2"><hr></td></tr>

  <tr>
    <td>
      <b>6. Profile Screen</b><br>
      <img src="https://github.com/user-attachments/assets/166c0e18-f7ae-43a3-9532-ece392c4bda1" width="200"/>
    </td>
    <td>
      - Kullanıcı bilgilerini gösterir (isim, ID, profil fotoğrafı)<br>
      - Favori filmler grid şeklinde görüntülenir<br>
      - Profil fotoğrafını ekleme veya değiştirme<br>
      - Alt navbar ile Home ve Profile sayfasına geçiş
    </td>
  </tr>
</table>

---

### Materials

- [API Documentation](https://caseapi.servicelabs.tech/api-docs/)  
- [UI Design (Figma)](https://www.figma.com/design/9TbWefkeGlVY96CrtsWLXg/Flutter-Dev-%C2%B7-Case-Study-NodeLab--Copy-?node-id=14001-61&t=zcU9kmzooCy7wSHG-1)  
- [Junior Case Boilerplate (GitHub)](https://github.com/nsilabs/nl_flutter_junior_case)  

---

### Installation

1. Flutter SDK’yı bilgisayarınıza kurun  
2. Depoyu klonlayın:
```bash
git clone https://github.com/kullaniciadi/Shartflix.git

