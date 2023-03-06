extends Node

const ID_PRODUCER_1:int = 0
const ID_CONSUMER_1:int = 1
const ID_CONSUMER_2:int = 2

# simulation defining parameters

#
var consumer_1_mutation_rate:int = 5 # 0 to 100
var consumer_2_mutation_rate:int = 5 # 0 to 100

#
var max_creator1:int = 1500
var max_consumer1:int = 300
var max_consumer2:int = 150

#
var consumer_1_lifetime_increase_after_eating:float = 10
var consumer_2_lifetime_increase_after_eating:float = 20

# 
var food_required_to_reproduce_consumer_1:int = 4
var food_required_to_reproduce_consumer_2:int = 2

var consumer_1_negative_input:int = ID_CONSUMER_2
var consumer_2_negative_input:int = ID_PRODUCER_1

var producer_1_min_TimerReproduce:float = 10.0
var producer_1_max_TimerReproduce:float = 30.0

var consumer_1_min_TimerLife:float = 15.0
var consumer_1_max_TimerLife:float = 30.0
var consumer_2_min_TimerLife:float = 20.0
var consumer_2_max_TimerLife:float = 45.0

var consumer_1_min_TimerReproduce:float = 5.0
var consumer_1_max_TimerReproduce:float = 10.0
var consumer_2_min_TimerReproduce:float = 5.0
var consumer_2_max_TimerReproduce:float = 10.0
