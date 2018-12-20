
# coding: utf-8

# In[51]:


from __future__ import print_function

feature_count = 42
predict_column = -2
target_cluster = 0

pop_size = 25
max_fitness = 3.0
max_gens = 80

pool_size = 15

seed_with = None #[0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]


# In[52]:


import sys
predict_column = int(sys.argv[1])
target_cluster = int(sys.argv[2])

print('col, cluster', predict_column, target_cluster)


# In[53]:


from pandas import DataFrame
import numpy as np
df = DataFrame.from_csv('pca_normed.csv')
df
#np.unique(df['Root_Cluster'])[:10]
#np.unique(df['Multi_Spike_1_Cluster'])[:10]


# In[54]:


protocol_cost = {
    'Steady State':       1, # 1s
    'Standard':         2, # 5 repetitions of 1s SS 1s stim
    'Strong':           2, # 5 repetitions of 1s SS 1s strong stim
    'Input Resistance': 2, # 2 levels of 1s SS 1s stim
    'Tripple': 8*2.2, # 8 frequencies 1.2 s each with 1 s SS
    'Ramp': 5, # up to 5s of injected current
}

prop_protocol = {
    'AP1Amplitude': 'Standard',
    'AP2Amplitude': 'Standard',
    'AP12AmplitudeDrop': 'Standard',
    'AP12AmplitudeChangePercent': 'Standard',
    'AP1SSAmplitudeChange': 'Standard'  ,
    
    'AP1WidthHalfHeight': 'Standard',
    'AP2WidthHalfHeight': 'Standard',
    'AP12HalfWidthChangePercent': 'Standard',
    
    'AP1WidthPeakToTrough': 'Standard',
    'AP2WidthPeakToTrough': 'Standard',
    
    'AP1RateOfChangePeakToTrough': 'Standard',
    'AP2RateOfChangePeakToTrough': 'Standard', 
    'AP12RateOfChangePeakToTroughPercentChange': 'Standard',
    
    'AP1AHPDepth': 'Standard',
    'AP2AHPDepth': 'Standard',
    'AP12AHPDepthPercentChange': 'Standard',
    
    'AP1DelayMean': 'Standard',
    'AP2DelayMean': 'Standard',
    
    'AP1DelaySD': 'Standard',
    'AP2DelaySD': 'Standard',
    
    'AP1DelayMeanStrongStim': 'Strong',
    'AP2DelayMeanStrongStim': 'Strong',
    
    'AP1DelaySDStrongStim': 'Strong',
    'AP2DelaySDStrongStim': 'Strong',
    
    'Burst1ISIMean': 'Standard',
    'Burst1ISIMeanStrongStim': 'Strong',
    
    'Burst1ISISD': 'Standard',
    'Burst1ISISDStrongStim': 'Strong',
    
    'InitialAccommodationMean': 'Standard',
    'SSAccommodationMean': 'Standard',
    'AccommodationRateToSS': 'Standard',
    'AccommodationAtSSMean': 'Standard',
    'AccommodationRateMeanAtSS': 'Standard',
    
    
    'ISIMedian': 'Standard',
    'ISICV': 'Standard',
    'ISIBurstMeanChange': 'Standard',
    
    'SpikeRateStrongStim': 'Strong',
    
    'InputResistance': 'Input Resistance',
    
    'SteadyStateAPs': 'Steady State',
    
    'FFPassAbove': 'Tripple',
    'FFPassBelow': 'Tripple',
    
    'RampSpikes': 'Ramp',
}

prop_names = [
    'AP1Amplitude',
    'AP2Amplitude',
    'AP12AmplitudeDrop',
    'AP12AmplitudeChangePercent',
    'AP1SSAmplitudeChange',  
    
    'AP1WidthHalfHeight',
    'AP2WidthHalfHeight',
    'AP12HalfWidthChangePercent',
    
    'AP1WidthPeakToTrough',
    'AP2WidthPeakToTrough',
    
    'AP1RateOfChangePeakToTrough',
    'AP2RateOfChangePeakToTrough',    
    'AP12RateOfChangePeakToTroughPercentChange',
    
    'AP1AHPDepth',
    'AP2AHPDepth',
    'AP12AHPDepthPercentChange',
    
    'AP1DelayMean',
    'AP2DelayMean',
    
    'AP1DelaySD',
    'AP2DelaySD',
    
    'AP1DelayMeanStrongStim',
    'AP2DelayMeanStrongStim',
    
    'AP1DelaySDStrongStim',
    'AP2DelaySDStrongStim',
    
    'Burst1ISIMean',
    'Burst1ISIMeanStrongStim',
    
    'Burst1ISISD',
    'Burst1ISISDStrongStim',
    
    'InitialAccommodationMean',
    'SSAccommodationMean',
    'AccommodationRateToSS',
    'AccommodationAtSSMean',
    'AccommodationRateMeanAtSS',
    
    
    'ISIMedian',
    'ISICV',
    'ISIBurstMeanChange',
    
    'SpikeRateStrongStim',
    
    'InputResistance',
    
    'SteadyStateAPs',
    
    'FFPassAbove',
    'FFPassBelow',
    
    'RampSpikes',
]

def columns_cost(columns):
    props = np.array(prop_names)[np.array(columns).nonzero()]

    protocols = list(np.unique(np.array([prop_protocol[prop] for prop in props])))

    total_cost = sum([protocol_cost[prot] for prot in protocols]) * 1.0
    
    print('props, prots, cost', props, protocols, total_cost)
    
    return total_cost


# In[55]:


#cols = [0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0]
#columns_cost(cols)


# In[56]:


#column_vector = [1] * feature_count
#target_cluster = 1
def train_model(column_vector = [1] * feature_count, plot = False):
    import tensorflow as tf
    import keras
    from pandas import DataFrame
    import numpy as np
    import pandas
    from matplotlib import pyplot as plt
    from sklearn.utils import class_weight

    pandas.set_option('display.max_columns', None)
    pandas.set_option('display.max_rows', 20)

    np.random.seed(1412)
    tf.set_random_seed(1412)

    df = DataFrame.from_csv('pca_normed.csv')

    # use just the selected columns + the label column
    df = df[[x for x in np.where(np.array(column_vector) == 1)[0]]+[predict_column]]
    
    # remove nan labels
    df.dropna(inplace=True)

    # Shuffle the rows
    order = np.argsort(np.random.random(df.values[:,-1].shape))
    df = df.values[order]

    test_fraction = 0.2


    cut_point = int(round(len(df)*test_fraction))
    test_set = df[:cut_point]
    train_set = df[cut_point:]

    (train_rows, train_labels), (test_rows,test_labels) = (train_set[:,0:-1], train_set[:,-1]), (test_set[:,0:-1], test_set[:,-1]), 
    train_labels = np.where(train_labels != target_cluster,0,1)
    test_labels = np.where(test_labels != target_cluster,0,1)

    print("total in train:",len(train_labels))
    print("targets in train:",len(np.where(train_labels == 1)[0]))
    print("targets in test: ",len(np.where(test_labels == 1)[0]))

    def match_targets(rows, labels):
        target_i = np.where(labels == 1)
        non_target_i = np.where(labels != 1)

        #print('non target',len(non_target_i[0]),'target',len(target_i[0]))

        if len(non_target_i[0]) >= len(target_i[0]):
            non_target_rows = rows[non_target_i]
            non_target_labels = labels[non_target_i]

            matching_nt_i = np.random.choice(non_target_rows.shape[0], len(target_i[0]), replace=False)
        else:
            matching_nt_i = non_target_i

            target_rows = rows[target_i]
            target_labels = labels[target_i]

            target_i = np.random.choice(target_rows.shape[0], len(non_target_i[0]), replace=False)

        rows = np.concatenate((rows[matching_nt_i], rows[target_i]))
        labels = np.concatenate((labels[matching_nt_i], labels[target_i]))

        order = np.argsort(np.random.random(len(rows)))
        rows = rows[order]
        labels = labels[order]

        return rows, labels

    train_rows, train_labels = match_targets(train_rows, train_labels)
    test_rows,  test_labels = match_targets(test_rows, test_labels)

    class PrintDot(keras.callbacks.Callback):
      def on_epoch_end(self, epoch, logs):
        if plot:
            if epoch % 100 == 0: 
                print(epoch)
        #    print('')
        #    print('.', end='')    

    def plot_history(histories, key='acc'): #binary_crossentropy
      plt.figure(figsize=(16,10))

      for name, history in histories:
        val = plt.plot(history.epoch, history.history['val_'+key],
                       '--', label=name.title()+' Val')
        plt.plot(history.epoch, history.history[key], color=val[0].get_color(),
                 label=name.title()+' Train')

      plt.xlabel('Epochs')
      plt.ylabel(key.replace('_',' ').title())
      plt.legend()

      plt.xlim([0,max(history.epoch)])

      print('train sample')
      plt.figure(figsize=(16,5))
      plt.plot(np.where(model.predict(train_rows) > 0.5, 1, 0))
      plt.plot(train_labels)
      #plt.xlim((0,150))

      print('test sample')
      plt.figure(figsize=(16,5))
      plt.plot(np.where(model.predict(test_rows) > 0.5, 1, 0))
      plt.plot(test_labels)
      #plt.xlim((0,150))
        
      plt.show()

    model = keras.Sequential([
            keras.layers.Dense(20, activation=keras.activations.relu, kernel_regularizer=keras.regularizers.l2(0.001)),
            keras.layers.Dropout(0.1),
            keras.layers.Dense(7, activation=keras.activations.relu, kernel_regularizer=keras.regularizers.l2(0.001)),
            keras.layers.Dropout(0.1),
            keras.layers.Dense(3, activation=keras.activations.relu, kernel_regularizer=keras.regularizers.l2(0.001)),
            keras.layers.Dropout(0.1),
            keras.layers.Dense(1, activation=keras.activations.sigmoid)
    ])

    model.compile(optimizer=keras.optimizers.SGD(lr=0.01, nesterov=True),
                 loss='binary_crossentropy',
                  metrics=['binary_accuracy', 'binary_crossentropy']
    )

    class_weights = class_weight.compute_class_weight('balanced',
                                                     np.unique(train_labels),
                                                     train_labels)

    early_stop = keras.callbacks.EarlyStopping(monitor='val_loss', patience=20, restore_best_weights=True)

    print('starting training...')
    
    history = model.fit(train_rows, 
              train_labels, 
              epochs=1000,
              validation_data=(test_rows, test_labels),
              callbacks=[early_stop, PrintDot()],
              class_weight=class_weights,
              verbose=0
    )

    print('training complete...')

    if plot:
        plot_history([('baseline', history)],key='binary_accuracy')

    result = model.evaluate(test_rows, test_labels)[1]

    print('best result', result, 'columns', sum(column_vector))

    return result


# In[57]:


#train_model(plot=True)


# In[58]:


# the goal ('fitness') function to be maximized
def evalOneMax(individual):
    columns = sum(individual)
    protocol_time = 0 #columns_cost(individual)
    
    try:
        best_acc = train_model(individual)
    except:
        print('Error evaluating', individual)
        best_acc = 0
    
    fit_cols = (feature_count - columns) / (1.0 * feature_count)
    fit_acc = best_acc
    fit_time = 1.0 - (protocol_time / 25.0)
    
    print('evaluated (cols, acc, time): ', fit_cols, fit_acc, fit_time)
        
    return fit_cols + fit_acc + fit_time, # Note the ',' at the end


mate_top_percent = 0.20
mutate_fraction = 0.05

# CXPB  is the probability with which two individuals
#       are crossed
#
# MUTPB is the probability for mutating an individual
CXPB, MUTPB = 0.5, 0.2

import random
import multiprocessing
from deap import base
from deap import creator
from deap import tools
from multiprocessing import Process, Pool
import os

creator.create("FitnessMax", base.Fitness, weights=(1.0,))
creator.create("Individual", list, fitness=creator.FitnessMax)

toolbox = base.Toolbox()

pool = Pool(pool_size, maxtasksperchild=1)

# Attribute generator 
#                      define 'attr_bool' to be an attribute ('gene')
#                      which corresponds to integers sampled uniformly
#                      from the range [0,1] (i.e. 0 or 1 with equal
#                      probability)
toolbox.register("attr_bool", random.randint, 0, 1)

# Structure initializers
#                         define 'individual' to be an individual
#                         consisting of 100 'attr_bool' elements ('genes')
toolbox.register("individual", tools.initRepeat, creator.Individual, toolbox.attr_bool, feature_count)

# define the population to be a list of individuals
toolbox.register("population", tools.initRepeat, list, toolbox.individual)

#----------
# Operator registration
#----------
# register the goal / fitness function
toolbox.register("evaluate", evalOneMax)

# register the crossover operator
toolbox.register("mate", tools.cxTwoPoint)

# register a mutation operator with a probability to
# flip each attribute/gene of 0.05
toolbox.register("mutate", tools.mutFlipBit, indpb=mutate_fraction)

# operator for selecting individuals for breeding the next
# generation: each individual of the current generation
# is replaced by the 'fittest' (best) of three individuals
# drawn randomly from the current generation.
toolbox.register("select", tools.selTournament, tournsize=int(pop_size*mate_top_percent))

random.seed(64)

# create an initial population of 300 individuals (where
# each individual is a list of integers)
pop = toolbox.population(n=pop_size)



# In[59]:


if seed_with is not None:
    print('seeding')
    for i in range(len(pop[0])):
        pop[0][i] = seed_with[i]


# In[47]:


print("Start of evolution")

# Evaluate the entire population
fitnesses = list(pool.map(toolbox.evaluate, pop))
for ind, fit in zip(pop, fitnesses):
    ind.fitness.values = fit

print("  Evaluated %i individuals" % len(pop))

# Extracting all the fitnesses of 
fits = [ind.fitness.values[0] for ind in pop]

# Variable keeping track of the number of generations
g = 0

# Begin the evolution
while max(fits) < max_fitness and g < max_gens:
    # A new generation
    g = g + 1
    print("-- Generation %i --" % g)

    # Select the next generation individuals
    offspring = toolbox.select(pop, len(pop))
    # Clone the selected individuals
    offspring = list(map(toolbox.clone, offspring))

    # Apply crossover and mutation on the offspring
    for child1, child2 in zip(offspring[::2], offspring[1::2]):

        # cross two individuals with probability CXPB
        if random.random() < CXPB:
            toolbox.mate(child1, child2)

            # fitness values of the children
            # must be recalculated later
            del child1.fitness.values
            del child2.fitness.values

    for mutant in offspring:

        # mutate an individual with probability MUTPB
        if random.random() < MUTPB:
            toolbox.mutate(mutant)
            del mutant.fitness.values

    # Evaluate the individuals with an invalid fitness
    invalid_ind = [ind for ind in offspring if not ind.fitness.valid]
    fitnesses = pool.map(toolbox.evaluate, invalid_ind)
    for ind, fit in zip(invalid_ind, fitnesses):
        ind.fitness.values = fit

    print("  Evaluated %i individuals" % len(invalid_ind))

    # The population is entirely replaced by the offspring
    pop[:] = offspring

    # Gather all the fitnesses in one list and print the stats
    fits = [ind.fitness.values[0] for ind in pop]

    length = len(pop)
    mean = sum(fits) / length
    sum2 = sum(x*x for x in fits)
    std = abs(sum2 / length - mean**2)**0.5

    print("  Min %s" % min(fits))
    print("  Max %s" % max(fits))
    print("  Avg %s" % mean)
    print("  Std %s" % std)

print("-- End of (successful) evolution --")

best_ind = tools.selBest(pop, 1)[0]
print("Best individual is %s, %s" % (best_ind, best_ind.fitness.values))

