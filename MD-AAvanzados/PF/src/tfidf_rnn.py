from keras.layers.core import Dense
from keras.layers.core import Flatten
from keras.layers.recurrent import LSTM
from keras.models import Sequential
from keras.preprocessing import sequence
from sklearn.feature_extraction.text import TfidfVectorizer

from src.util.utilities import *


def tfidf_rnn(train_xs, train_ys, test_xs, test_ys=None, verbose=1):
    own_set_seed()

    # Representation
    tfidf_parser = TfidfVectorizer(tokenizer=tokenize, lowercase=False, analyzer='word')

    train_sparse_matrix_features_tfidf = tfidf_parser.fit_transform(train_xs)
    test_sparse_matrix_features_tfidf = tfidf_parser.transform(test_xs)

    train_features_tfidf = []
    own_train_features_tfidf_append = train_features_tfidf.append
    lengths_tweets = []
    own_lengths_tweets_append = lengths_tweets.append

    for tweet in train_sparse_matrix_features_tfidf:
        own_train_features_tfidf_append(tweet.data)
        own_lengths_tweets_append(len(tweet.data))

    test_features_tfidf = [tweet.data for tweet in test_sparse_matrix_features_tfidf]
    # Average length
    max_len_input = int(np.max(lengths_tweets, 0))
    # lstm_output_dim = int(2**np.log2(max_len_input))

    # NN model
    nn_model = Sequential()
    nn_model.add(LSTM(64, input_shape=(max_len_input, 1), return_sequences=True))
    nn_model.add(Dense(32, activation='tanh'))
    nn_model.add(Flatten())
    nn_model.add(Dense(len(src.util.global_vars.__CLASSES__), activation='softmax'))
    nn_model.compile(optimizer="adam", loss="sparse_categorical_crossentropy")

    if verbose == 1:
        print(nn_model.summary())

    train_features_tfidf_pad = sequence.pad_sequences(train_features_tfidf, maxlen=max_len_input,
                                                      padding="post", truncating="post",
                                                      dtype=train_sparse_matrix_features_tfidf.dtype)
    train_features_tfidf_pad = np.expand_dims(train_features_tfidf_pad, axis=-1)

    np_labels_train = np.array(train_ys)

    test_features_tfidf_pad = sequence.pad_sequences(test_features_tfidf, maxlen=max_len_input,
                                                     padding="post", truncating="post",
                                                     dtype=test_sparse_matrix_features_tfidf.dtype)
    test_features_tfidf_pad = np.expand_dims(test_features_tfidf_pad, axis=-1)

    history = None
    if test_ys is None:
        nn_model.fit(train_features_tfidf_pad, np_labels_train, batch_size=32, epochs=10, verbose=verbose)
    else:
        history = nn_model.fit(train_features_tfidf_pad, np_labels_train,
                               validation_data=(test_features_tfidf_pad, test_ys), batch_size=32, epochs=10,
                               verbose=verbose)

    y_labels = nn_model.predict_classes(test_features_tfidf_pad, batch_size=32, verbose=verbose)

    return y_labels, history
