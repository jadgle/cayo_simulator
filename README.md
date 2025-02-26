# Towards a Quantitative Understanding of Collective Animal Behaviour Under Climatic Events

Climate change poses significant threats to biodiversity, with extreme weather events such as hurricanes and wildfires devastating animal populations at unprecedented scales. Animals exhibit collective behaviours to respond to such threats, emerging from interactions among individuals within a group. Understanding these interaction dynamics is key to uncovering self-organization and decision-making mechanisms in animal populations. This project set out to understand collective animal behaviour through a combination of mathematical modeling, simulations, and empirical data collection. 

## Case Study  

The survival of 98% of the macaque population in Cayo Santiago during Hurricane Maria in 2017 was chosen as the primary case study. This event provided a unique opportunity to study the role of collective behaviour in extreme climatic events and served as the foundation for developing a mathematical model.

## Mathematical Modeling  

A dynamical system was developed to represent macaque populations as interacting agents driven by a combination of interaction forces and self-propulsion. A two-population model was constructed to distinguish followers from leaders, incorporating alignment, repulsion from the hurricane, and leader anticipation of the hurricane’s trajectory.

The colony is modeled as a **system of interacting agents**, where each individual is influenced by both **endogenous** (social interactions) and **exogenous** (environmental) forces.

### **Endogenous Forces (Social Interactions)**  
Agents interact within a local neighborhood, consisting of a fixed number of closest agents, including a leader. The forces considered include:  

- **Attraction:** Macaques are attracted to each other beyond a certain distance to maintain group cohesion.  
- **Repulsion:** Short-range repulsion prevents overcrowding and collisions.  
- **Leader-Follower Dynamics:** Leaders have stronger attraction influence, guiding the group towards safe areas.  

### **Exogenous Forces (Environmental Influence)**  
The environment exerts external influences on the macaques, including:  

- **Wind Influence:** A force pushing individuals perpendicular to the wind direction, simulating the storm's impact.  
- **Storm Repulsion:** A repulsive force from the storm center, increasing as the storm approaches.  
- **Leader Anticipation:** Leaders can foresee the storm trajectory within a short time window, adjusting their movement accordingly.  

## Simulations  

Computational experiments simulated the movement of a macaque group in response to a modeled tornado on Cayo Santiago. The results highlighted the **critical role of leadership and anticipatory behaviour** in ensuring group survival. Simulations confirmed that **mortality rates significantly increase when leader anticipation is absent**, demonstrating the importance of informed decision-making during extreme events.  

### **Results (GIFs of Simulations)**  

![Simulation 1](path_to_simulation_1.gif)  
*Simulation of macaques responding to an approaching storm.*  

![Simulation 2](path_to_simulation_2.gif)  
*Comparison of survival outcomes with and without leader anticipation.*  

---

## How to Use the Code  

1. **Clone the Repository:**  
   ```sh
   git clone https://github.com/your-repo-name.git
   cd your-repo-name
