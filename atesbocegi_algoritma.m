function atesbocegi_algoritma 
n=20;                   % Nüfus büyüklüğü (ateş böceklerinin sayısı)
alpha=1.0;              % Rastlantı değişkeni.
beta0=1.0;              % çekicilik sabiti
gamma=0.01;             % Sabit emilim katsayısı.
theta=0.97;             % Rastgelelik azaltma faktörü =10^(-5/tMax) 
d=10;                   % Boyut sayısı
tMax=500;               % Maksimum yineleme sayısı
Lb=-10*ones(1,d);       % Alt sınırlar/limitler
Ub=10*ones(1,d);        % Üst sınırlar/limitler
% n sayıda ateşböceğinin başlangıç ​​konumlarının oluşturulması.
for i=1:n,
   ns(i,:)=Lb+(Ub-Lb).*rand(1,d);         % rastgeleleştirme
   Lightn(i)=cost(ns(i,:));               % Hedefleri değerlendirme.
end
% fbest=değerlendirilen en iyi hedef,nbest=değerlendirilen böceğin konumu
%%%%%%%%%%%%%%%%% Yinelemeleri başlat (ana döngü) %%%%%%%%%%%%%%%%%%%%%%%
for k=1:tMax,        
 alpha=alpha*theta;     % Alfayı bir faktör teta kadar azaltır.
 scale=abs(Ub-Lb);      % Optimizasyon probleminin ölçeği.
% n sayıda ateşböceğinin üzerindeki ikinci döngü
for i=1:n,
    for j=1:n,
      % Mevcut çözümlerin objektif değerlerini değerlendir.
      Lightn(i)=cost(ns(i,:));           % Hedefi ara
      % Hareketleri güncelle
      if Lightn(i)>=Lightn(j),           % Daha parlak/daha çekici
         r=sqrt(sum((ns(i,:)-ns(j,:)).^2));
         beta=beta0*exp(-gamma*r.^2);    % çekicilik
         steps=alpha.*(rand(1,d)-0.5).*scale;
      % Konum vektörlerini güncellemek için FA denklemi
         ns(i,:)=ns(i,:)+beta*(ns(j,:)-ns(i,:))+steps;
      end
   end % j yi sonlandır
end % i yi sonlandır.

% Yeni çözümlerin/konumların sınırlar içinde olup olmadığını kontrol et.
ns=findlimits(n,ns,Lb,Ub);
%% Ateşböceklerini ışık yoğunluğuna/hedeflerine göre sırala.
[Lightn,Index]=sort(Lightn);
nsol_tmp=ns;
for i=1:n,
 ns(i,:)=nsol_tmp(Index(i),:);
end
%% Mevcut en iyi çözümü bul ve çıktıları görüntüle.
fbest=Lightn(1), nbest=ns(1,:)
end % Ana FA döngüsünün sonu (tMax'e kadar) 

% Yeni ateşböceklerinin sınırlar/sınırlar içinde olduğundan emin olun
function [ns]=findlimits(n,ns,Lb,Ub)
for i=1:n,
  nsol_tmp=ns(i,:);
  % Alt sınırı uygula
  I=nsol_tmp<Lb;  nsol_tmp(I)=Lb(I);
  % Üst sınırları uygula
  J=nsol_tmp>Ub;  nsol_tmp(J)=Ub(J);
  % Bu yeni hareketi güncelle
  ns(i,:)=nsol_tmp;
end

%% Amaç fonksiyonunu veya maliyet fonksiyonunu tanımlayın
function z=cost(x)
% Değiştirilmiş küre fonksiyonu: z=sum_{i=1}^D (x_i-1)^2
z=sum((x-1).^2); % küresel minimum fmin=0 ye kadar (1,1,...,1)
% döngü 500 e yakın kere tekrar eder çünkü amaç en iyi sonucu bulmaktır.%