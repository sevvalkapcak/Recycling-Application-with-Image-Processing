import os
import cv2
import numpy as np
import tensorflow as tf
from keras import layers, models
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
from keras.models import Sequential
from keras.layers import Dense, Flatten, Dropout

# Verilerin yuklenmesi ve islenmesi
veri_seti = 'geridonusum_train'

class_names = os.listdir(veri_seti)
class_paths = [os.path.join(veri_seti, cls) for cls in class_names]

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

# CNN modelinin olusturulmasi
model = models.Sequential([
    layers.Conv2D(32, (3, 3), activation='relu', input_shape=(128, 128, 3)),
    layers.MaxPooling2D((2, 2)),
    layers.Conv2D(64, (3, 3), activation='relu'),
    layers.MaxPooling2D((2, 2)),
    layers.Conv2D(128, (3, 3), activation='relu'),
    layers.MaxPooling2D((2, 2)),
    layers.Flatten(),
    layers.Dense(128, activation='relu'),
    layers.Dropout(0.5),
    layers.Dense(len(class_names), activation='softmax')
])

# Modelin compile edilmesi
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])

# Modelin egitilmesi
model.fit(train_images, train_labels, epochs=10, batch_size=32, validation_data=(test_images, test_labels))

# Modelin geçmis bilgisi
history = model.fit(train_images, train_labels, epochs=10, batch_size=32, validation_data=(test_images, test_labels))

# Modelin kaydedilmesi
model.save("geridonusum_modeli.h5")

# loss ve accuracy degerlerinin goruntulenmesi
train_loss = history.history['loss']
train_acc = history.history['accuracy']
epochs = range(1, len(train_loss) + 1)

plt.figure(figsize=(8, 4))

plt.plot(epochs, train_loss, 'b', label='Eğitim Kaybı')
plt.plot(epochs, train_acc, 'r', label='Eğitim Doğruluğu')
plt.title('Eğitim Kaybı ve Doğruluğu')
plt.xlabel('Epochs')
plt.ylabel('Loss / Accuracy')
plt.legend()

plt.show()

