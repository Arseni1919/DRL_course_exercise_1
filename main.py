# -*- coding: utf-8 -*-

from World import World
import numpy as np
import random
# random.seed(0)

# --------------------- PARAMETERS --------------------- #
r = -0.04
teta = 0.0001
omega = 0.9

# ------------------------------------------------------ #
# --------------------- CONSTANTS ---------------------- #
N = 1
E = 2
S = 3
W = 4
ACTIONS = [N, E, S, W]
FINAL_STATE_CELLS = [0, 6, 12, 13, 14]
BAD_CELLS = [0, 6, 13, 14]
GOOD_CELLS = [12]
# ------------------------------------------------------ #

class Cell:
    def __init__(self, num, n, s, w, e):
        self.num = num
        self.n = n
        self.e = e
        self.s = s
        self.w = w


# create cells and tell them who are their neighbours
field = {
    0: Cell(0, 0, 1, 0, 4),
    1: Cell(1, 0, 2, 1, 5),
    2: Cell(2, 1, 3, 2, 6),
    3: Cell(3, 2, 3, 3, 7),
    4: Cell(4, 4, 5, 0, 8),
    5: Cell(5, 4, 6, 1, 9),
    6: Cell(6, 5, 7, 2, 10),
    7: Cell(7, 6, 7, 3, 11),
    8: Cell(8, 8, 9, 4, 12),
    9: Cell(9, 8, 10, 5, 13),
    10: Cell(10, 9, 11, 6, 14),
    11: Cell(11, 10, 11, 7, 15),
    12: Cell(12, 12, 13, 8, 12),
    13: Cell(13, 12, 14, 9, 13),
    14: Cell(14, 13, 15, 10, 14),
    15: Cell(15, 14, 15, 11, 15),
}


def transition_model(new_state, state, action):
    if state in FINAL_STATE_CELLS:
        raise ValueError('Game Over')
    if action == N:
        if field[state].n == new_state:
            return 0.8
        if new_state in [field[state].w, field[state].e]:
            return 0.1
    if action == S:
        if field[state].s == new_state:
            return 0.8
        if new_state in [field[state].w, field[state].e]:
            return 0.1
    if action == W:
        if field[state].w == new_state:
            return 0.8
        if new_state in [field[state].n, field[state].s]:
            return 0.1
    if action == E:
        if field[state].e == new_state:
            return 0.8
        if new_state in [field[state].n, field[state].s]:
            return 0.1
    return 0


def reward_function(state):
    if state in BAD_CELLS:
        return -1
    if state in GOOD_CELLS:
        return 1
    return r


def initiate_values(nStates):
    values = {}
    for state in range(nStates):
        values[state] = 0
    return values


def max_action_value(curr_world, state, curr_values):
    if state in FINAL_STATE_CELLS:
        return reward_function(state), 1
    value = None
    best_action = 1
    for counter, action in enumerate(ACTIONS):
        curr_sum = get_value_on_action(state, action, curr_values, curr_world)
        if counter == 0:
            value = curr_sum
        if curr_sum > value:
            value = curr_sum
            best_action = action
    return value, best_action


def get_policy(curr_world, curr_values):
    curr_policy = []
    for state in range(curr_world.nStates):
        _, action = max_action_value(curr_world, state, curr_values)
        curr_policy.append([action])
    return np.array(curr_policy)


# ------------------------------ #
def value_iteration(curr_world):
    values = initiate_values(curr_world.nStates)
    delta = teta
    while not delta < teta:
        delta = 0
        for state in range(curr_world.nStates):
            value = values[state]
            values[state], _ = max_action_value(curr_world, state, values)
            delta = max(delta, abs(value - values[state]))
    policy = get_policy(curr_world, values)
    return values, policy
# ------------------------------ #


def initialize_policy(curr_world):
    policy = []
    for state in range(curr_world.nStates):
        # policy.append([random.choice(ACTIONS)])
        policy.append([1])
    return policy


def get_value_on_action(state, action, values, curr_world):
    if state in FINAL_STATE_CELLS:
        return reward_function(state)
    value = 0
    for new_state in range(curr_world.nStates):
        value += transition_model(new_state, state, action) * (reward_function(state) + omega * values[new_state])
    return value


def policy_evaluation(policy, curr_world):
    values = initiate_values(curr_world.nStates)
    delta = teta
    while not delta < teta:
        delta = 0
        for state in range(curr_world.nStates):
            value = values[state]
            values[state] = get_value_on_action(state, policy[state][0], values, curr_world)
            delta = max(delta, abs(value - values[state]))
    return values


def policy_improvement(values, curr_world):
    policy = []
    for state in range(curr_world.nStates):
        max_q_val = None
        max_action_val = ACTIONS[0]
        for index, action in enumerate(ACTIONS):
            q_val = get_value_on_action(state, action, values, curr_world)

            if index == 0:
                max_q_val = q_val
                max_action_val = action
            if q_val > max_q_val:
                max_q_val = q_val
                max_action_val = action
        policy.append([max_action_val])
    return policy


# ------------------------------ #
def policy_iteration(curr_world):
    policy = initialize_policy(curr_world)
    values = {}
    policy_stable = False
    while not policy_stable:
        values = policy_evaluation(policy, curr_world)
        new_policy = policy_improvement(values, curr_world)

        policy_stable = True
        for i in range(len(policy)):
            if policy[i][0] != new_policy[i][0]:
                policy_stable = False
                break

        policy = new_policy

        world.plot_value(values)
        world.plot_policy(np.array(policy))

    return values, np.array(policy)
# ------------------------------ #


if __name__ == "__main__":

    world = World()
    # world.plot()

    # final_values, final_policy = value_iteration(world)
    final_values, final_policy = policy_iteration(world)

    # world.plot_value(final_values)
    # world.plot_policy(final_policy)
