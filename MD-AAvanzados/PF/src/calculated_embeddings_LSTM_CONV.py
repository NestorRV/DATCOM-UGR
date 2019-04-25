from keras.layers import MaxPooling1D, Conv1D, AveragePooling1D
from keras.layers.core import Dense, Dropout
from keras.layers.core import Flatten
from keras.layers.embeddings import Embedding
from keras.layers.recurrent import LSTM
from keras.models import Sequential
from keras.preprocessing import sequence

from src.util.utilities import *


def calculated_embeddings_LSTM_CONV(train_xs, train_ys, test_xs, test_ys=None, epochs=25, verbose=1):
    own_set_seed()

    # Build vocabulary and corpus indexes
    vocabulary_train, corpus_train_index = fit_transform_vocabulary(train_xs)

    max_len_input = int(np.max([len(tweet_train) for tweet_train in corpus_train_index], 0))

    corpus_test_index = []
    own_corpus_test_index_append = corpus_test_index.append
    for tweet_test in test_xs:
        tokens_test = tokenize(tweet_test)
        own_corpus_test_index_append([vocabulary_train.get(token_test, 1)
                                      for token_test in tokens_test])

    nn_model = Sequential()
    nn_model.add(Embedding(len(vocabulary_train) + 2, 100, input_length=max_len_input, trainable=False))
    nn_model.add(LSTM(64, return_sequences=True))
    nn_model.add(Dropout(0.5))
    nn_model.add(MaxPooling1D())

    nn_model.add(Conv1D(128, 5, activation='relu', padding='same'))
    nn_model.add(Dropout(0.5))
    nn_model.add(AveragePooling1D())

    nn_model.add(Dense(128, activation='relu'))
    nn_model.add(Dropout(0.5))
    nn_model.add(AveragePooling1D())

    nn_model.add(Flatten())
    nn_model.add(Dense(len(src.util.global_vars.__CLASSES__), activation='softmax'))

    nn_model.compile(loss='sparse_categorical_crossentropy', optimizer='adam')

    if verbose == 1:
        print(nn_model.summary())

    train_features_pad = sequence.pad_sequences(corpus_train_index, maxlen=max_len_input, padding="post",
                                                truncating="post", dtype=type(corpus_train_index[0][0]))
    np_labels_train = np.array(train_ys)

    test_features_pad = sequence.pad_sequences(corpus_test_index, maxlen=max_len_input, padding="post",
                                               truncating="post", dtype=type(corpus_test_index[0][0]))

    history = None
    if test_ys is None:
        nn_model.fit(train_features_pad, np_labels_train, batch_size=32, epochs=epochs, verbose=verbose)
    else:
        history = nn_model.fit(train_features_pad, np_labels_train, validation_data=(test_features_pad, test_ys),
                               batch_size=32, epochs=epochs, verbose=verbose)

    y_labels = nn_model.predict_classes(test_features_pad, batch_size=32, verbose=verbose)
    return y_labels, history
