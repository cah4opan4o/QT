import random
import numpy as np
import matplotlib.pyplot as plt
import networkx as nx

# Шаг 1: Определение матрицы переходов и состояний
transition_matrix = np.array([[0, 0.5, 0.5, 0],
                              [0.33, 0, 0.33, 0.33],
                              [0.33, 0.33, 0, 0.33],
                              [0.33, 0.33, 0.33, 0]])

states = ["Healthy", "Unwell", "Sick", "Very sick"]

# Шаг 2: Нормализация строк матрицы (если это нужно)
row_sums = transition_matrix.sum(axis=1)
normalized_matrix = transition_matrix / row_sums[:, np.newaxis]

# Шаг 3: Создание графа для визуализации
G = nx.DiGraph()

# Шаг 4: Добавление узлов и рёбер с вероятностями
for i in range(len(states)):
    for j in range(len(states)):
        if normalized_matrix[i, j] > 0:
            G.add_edge(states[i], states[j], weight=normalized_matrix[i, j])

# Шаг 5: Визуализация графа с весами
pos = nx.spring_layout(G)
edges = G.edges(data=True)

# Визуализация графа с размерами и цветами рёбер в зависимости от вероятностей переходов
edge_weights = [edge[2]['weight'] for edge in edges]
nx.draw(G, pos, with_labels=True, node_color='lightblue', font_weight='bold', node_size=3000)
nx.draw_networkx_edge_labels(G, pos, edge_labels={(u, v): f'{d["weight"]:.2f}' for u, v, d in edges})
nx.draw(G, pos, with_labels=True, node_color='lightblue', edge_color=edge_weights, edge_cmap=plt.cm.Blues, width=2)

# Сохранение графа
plt.title('Markov Chain Transition Graph')
plt.savefig('markov_chain_graph.png')
plt.show()

# Функция для симуляции цепи Маркова
def simulate_markov_chain(transition_matrix, states, initial_state, num_steps):
    state = initial_state
    state_sequence = [states[state]]
    
    for _ in range(num_steps):
        r = random.uniform(0, 1)
        cumulative_sum = 0
        for i, prob in enumerate(transition_matrix[state]):
            cumulative_sum += prob
            if r <= cumulative_sum:
                state = i
                break
        state_sequence.append(states[state])
    
    return state_sequence

# Параметры симуляции
initial_state = 0  # Начальное состояние: "Healthy"
num_steps = 200  # Количество шагов

# Симуляция цепи Маркова
state_sequence = simulate_markov_chain(normalized_matrix, states, initial_state, num_steps)

