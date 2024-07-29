import tensorflow as tf
import numpy as np
from sklearn.model_selection import train_test_split
import os
import cv2
import matplotlib.pyplot as plt


# Modelin yuklenmesi
model = tf.keras.models.load_model('geridonusum_modeli.h5')

# Tahmin edilmesi istenen goruntuler
resimler = 'geridonusum_veriseti'

class_names = os.listdir(resimler)
class_paths = [os.path.join(resimler, cls) for cls in class_names]

images = []
labels = []
for i, cls_path in enumerate(class_paths):
    for img_name in os.listdir(cls_path):
        img_path = os.path.join(cls_path, img_name)
        try:
            img = cv2.imread(img_path)
            if img is None:
                print(f"Resim yüklenemedi: {img_path}")
                continue
            img = cv2.resize(img, (128, 128))
            images.append(img)
            labels.append(i)
        except Exception as e:
            print(f"Hata: {e} - Dosya: {img_path}")

images = np.array(images)
labels = np.array(labels)

# Veri setinin egitim ve test seti olarak bolunmesi
train_images, test_images, train_labels, test_labels = train_test_split(images, labels, test_size=0.2, random_state=42)


# 50 adet ornek gosterilmesi
num_samples_to_display = 50

# Rastgele orneklerin indekslerinin secilmesi
random_indexes = np.random.choice(len(test_images), num_samples_to_display, replace=False)

dogru = 0
for i, idx in enumerate(random_indexes):
    sample_image = test_images[idx]
    sample_label = test_labels[idx]

    prediction = model.predict(np.expand_dims(sample_image, axis=0))
    predicted_class = np.argmax(prediction)

    # Gercek ve tahmin etiketlerinin yazdirilmasi
    print(f"Örnek {i + 1}:")
    print("Gerçek Etiket:", class_names[sample_label])

    # Görüntüleri ekrana bastırma
    plt.figure(figsize=(4, 2))


    plt.subplot(1, 2, 1)
    plt.imshow(sample_image)
    plt.title('Gerçek Görüntü: {}, Tahmini Etiket: {}'.format(class_names[sample_label], class_names[predicted_class]))
    if class_names[sample_label] == class_names[predicted_class]:
        dogru += 1
    plt.axis('off')

    plt.tight_layout()
    plt.show()

print("dogru sayisi= ", dogru)