# from main import *
import numpy as np
print(np.random.randint(1, 4, (16, 1)))

pol = []
for i in range(16):
    pol.append([1])

print('---')
print(np.array(pol))

# policy = np.zeros((world.nStates, world.nActions))
# # print(policy)
# for state in range(world.nStates):
#      vec = np.random.random(4)
#      sum = np.sum(vec)
#      policy[state][0] = vec[0] / sum
#      policy[state][1] = vec[1] / sum
#      policy[state][2] = vec[2] / sum
#      policy[state][3] = vec[3] / sum
#
# policy = np.asarray(policy, dtype=np.float32)
# print(policy)
# world.plot_policy(policy)
# this is my adding