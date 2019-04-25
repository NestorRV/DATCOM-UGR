from keras.layers.core import Dense
from keras.layers.core import Flatten
from keras.layers.embeddings import Embedding
from keras.layers.recurrent import LSTM
from keras.models import Sequential
from keras.optimizers import Adam
from keras.preprocessing import sequence

from src.util.utilities import *


def pretrain_embeddings_rnn(embeddings_path, train_xs, train_ys, test_xs, test_ys=None, epochs=25, learning_rate=0.001,
                            verbose=1):
    own_set_seed()

    # Offset = 2; Padding and OOV.
    word_embeddings, word_emb_indexes = read_embeddings(embeddings_path, 2)
    word_embeddings[0] = 2 * 0.1 * np.random.rand(len(word_embeddings[2])) - 1
    word_embeddings[1] = 2 * 0.1 * np.random.rand(len(word_embeddings[2])) - 1

    # Build vocabulary and corpus indexes
    vocabulary_train, corpus_train_index = fit_transform_vocabulary_pretrain_embeddings(train_xs, word_emb_indexes)

    max_len_input = int(np.average([len(tweet_train) for tweet_train in corpus_train_index], 0))

    corpus_test_index = []
    own_corpus_test_index_append = corpus_test_index.append
    own_lowercase = str.lower
    for tweet_test in test_xs:
        tokens_test = tokenize(own_lowercase(tweet_test))
        doc_test_index = []
        for token_test in tokens_test:
            if RE_TOKEN_USER.fullmatch(token_test) is not None:
                token_test = "@user"
            doc_test_index.append(word_emb_indexes.get(token_test, 1))
        own_corpus_test_index_append(doc_test_index)

    nn_model = Sequential()
    nn_model.add(Embedding(len(word_embeddings), len(word_embeddings[0]), weights=[np_array(word_embeddings)],
                           input_length=max_len_input, trainable=False))
    nn_model.add(LSTM(64, return_sequences=True))
    nn_model.add(Dense(32, activation='tanh'))
    nn_model.add(Flatten())
    nn_model.add(Dense(len(src.util.global_vars.__CLASSES__), activation='softmax'))
    adam_optimizer = Adam(lr=learning_rate)
    nn_model.compile(optimizer=adam_optimizer, loss="sparse_categorical_crossentropy")

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
