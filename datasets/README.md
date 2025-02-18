# Flower Datasets

[![GitHub license](https://img.shields.io/github/license/adap/flower)](https://github.com/adap/flower/blob/main/LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/adap/flower/blob/main/CONTRIBUTING.md)
![Build](https://github.com/adap/flower/actions/workflows/framework.yml/badge.svg)
![Downloads](https://pepy.tech/badge/flwr)
[![Slack](https://img.shields.io/badge/Chat-Slack-red)](https://flower.dev/join-slack)

Flower Datasets (`flwr-datasets`) is a library to quickly and easily create datasets for federated learning, federated evaluation, and federated analytics. It was created by the `Flower Labs` team that also created Flower: A Friendly Federated Learning Framework. 
Flower Datasets library supports:
* **downloading datasets** - choose the dataset from Hugging Face's `datasets`,
* **partitioning datasets** - customize the partitioning scheme,
* **creating centralized datasets** - leave parts of the dataset unpartitioned (e.g. for centralized evaluation).

Thanks to using Hugging Face's `datasets` used under the hood, Flower Datasets integrates with the following popular formats/frameworks:
* Hugging Face,
* PyTorch, 
* TensorFlow, 
* Numpy, 
* Pandas, 
* Jax,
* Arrow.

Create **custom partitioning schemes** or choose from the **implemented partitioning schemes**:
* IID partitioning `IidPartitioner(num_partitions)`
* more to come in future releases.

# Installation

## With pip

Flower Datasets can be installed from PyPi

```bash
pip install flwr-datasets

If you plan to change the type of the dataset to run the code with your ML framework, make sure to have it installed too.

# Usage

The Flower Datasets exposes `FederatedDataset(dataset, partitioners)` abstraction to represent the dataset needed for federated learning/analytics. It has two powerful methods that let you handle the dataset preprocessing. They are `load_partition(idx, split)` and `load_full(split)`.

Here's a quick example of how to partition the MNIST dataset:


`FederatedDataset(dataset, partitioners)` allows you specification of:

* `dataset:str` - the name of the dataset.

* `partitioners: Dict[str: int]` - `{split_name: str` to `number-of-partitions: int}` - partitioner that will be used with an associated split of the dataset e.g. `{"train": 100}`. It assumes by default the i.i.d. partitioning.

More customization of `partitioners` is coming in future releases. 

# Future release

Here are a few of the things that we will work on in future releases:

* Support for more datasets (especially the ones that have user id present).
* Creation of custom `Partitioner`s.
* More out-of-the-box `Partitioner`s.
* Passing `Partitioner`s via `FederatedDataset`'s `partitioner` argument. 
* Customization of the dataset splitting before the partitioning.
* Simplification of the dataset transformation to the popular frameworks/types.
* Creation of the synthetic data,
* Support for Vertical FL.
