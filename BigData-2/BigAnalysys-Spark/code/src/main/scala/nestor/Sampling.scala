package main.scala.nestor

import org.apache.spark.SparkContext
import org.apache.spark.mllib.linalg.Vectors
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.rdd.RDD

object Sampling {

  def ROS(sc: SparkContext, path: String, majClass: String, minClass: String, rate: Double = 1.0): RDD[LabeledPoint] = {
    val train = sc.textFile(path, minPartitions = 250).cache
    val train_positive = train.filter(line => line.split(",").last.compareToIgnoreCase(minClass) == 0)
    val train_negative = train.filter(line => line.split(",").last.compareToIgnoreCase(majClass) == 0)

    val num_neg = train_negative.count()
    val num_pos = train_positive.count()

    val oversampled: RDD[String] = if (num_pos > num_neg) {
      val fraction = (num_pos * (rate.toFloat / 100)) / num_neg
      train_positive.union(train_negative.sample(withReplacement = true, fraction, 0L))
    } else {
      val fraction = (num_neg * (rate.toFloat / 100)) / num_pos
      train_negative.union(train_positive.sample(withReplacement = true, fraction, 0L))
    }

    val oversampled_final = oversampled.map { line =>
      val array = line.split(",")
      val arrayDouble = array.map(f => f.toDouble)
      val featureVector = Vectors.dense(arrayDouble.init)
      val label = arrayDouble.last
      LabeledPoint(label, featureVector)
    }

    oversampled_final
  }


  def ROS_data(sc: SparkContext, train: RDD[LabeledPoint], majClass: Double, minClass: Double, rate: Double = 1.0): RDD[LabeledPoint] = {
    val train_positive = train.filter(point => point.label == minClass).cache
    val train_negative = train.filter(point => point.label == majClass).cache

    val num_neg = train_negative.count()
    val num_pos = train_positive.count()

    val oversampled: RDD[LabeledPoint] = if (num_pos > num_neg) {
      val fraction = (num_pos * (rate.toFloat / 100)) / num_neg
      train_positive.union(train_negative.sample(withReplacement = true, fraction, 0L))
    } else {
      val fraction = (num_neg * (rate.toFloat / 100)) / num_pos
      train_negative.union(train_positive.sample(withReplacement = true, fraction, 0L))
    }

    oversampled
  }

  def RUS(sc: SparkContext, path: String, majClass: String, minClass: String): RDD[LabeledPoint] = {
    val train = sc.textFile(path, minPartitions = 250).cache
    val train_positive = train.filter(line => line.split(",").last.compareToIgnoreCase(minClass) == 0)
    val train_negative = train.filter(line => line.split(",").last.compareToIgnoreCase(majClass) == 0)

    val num_neg = train_negative.count()
    val num_pos = train_positive.count()

    val undersampled: RDD[String] = if (num_pos > num_neg) {
      val fraction = num_neg.toFloat / num_pos
      train_negative.union(train_positive.sample(withReplacement = false, fraction, 0L))
    } else {
      val fraction = num_pos.toFloat / num_neg
      train_positive.union(train_negative.sample(withReplacement = false, fraction, 0L))
    }

    val undersampled_final = undersampled.map { line =>
      val array = line.split(",")
      val arrayDouble = array.map(f => f.toDouble)
      val featureVector = Vectors.dense(arrayDouble.init)
      val label = arrayDouble.last
      LabeledPoint(label, featureVector)
    }

    undersampled_final
  }
}
