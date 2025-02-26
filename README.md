# Towards a Quantitative Understanding of Collective Animal Behaviour Under Climatic Events

Climate change poses significant threats to biodiversity, with extreme weather events such as hurricanes and wildfires devastating animal populations at unprecedented scales. Animals exhibit collective behaviours to respond to such threats, emerging from interactions among individuals within a group. Understanding these interaction dynamics is key to uncovering self-organization and decision-making mechanisms in animal populations. This project set out to understand collective animal behaviour through a combination of mathematical modeling, simulations, and empirical data collection. 

## Case Study  

The survival of 98% of the macaque population in Cayo Santiago during Hurricane Maria in 2017 was chosen as the primary case study. This event provided a unique opportunity to study the role of collective behaviour in extreme climatic events and served as the foundation for developing a mathematical model.

## Mathematical Modeling  

A dynamical system was developed to represent macaque populations as interacting agents driven by a combination of interaction forces and self-propulsion. A two-population model was constructed to distinguish followers from leaders, incorporating alignment, repulsion from the hurricane, and leader anticipation of the hurricane’s trajectory.

The colony is modeled as a **system of interacting agents**, where each individual is influenced by both **endogenous** (social interactions) and **exogenous** (environmental) forces.

- Agents interact within a **local neighborhood**, consisting of a fixed number of closest agents, including a leader. The forces considered include a **long-range attraction** and **short-range repulsion**. The idea is that macaques want to maintain some level of **group cohesion** while preventing overcrowding and collisions.
- Agents are also influenced by the **environment**, in this case the **moving storm**. This is represented in our model as a **wind-induced perpendicular movement** combined with a **repulsion from the storm center**.
- The colony has a **hierarchical social structure**, where groups of macaques follow a **leader**.  
  - Leaders are assumed to be **experienced elders** with knowledge of extreme events and safe routes.  
  - Macaques with **stronger social ties**—especially those with access to leaders—are more likely to **survive the hurricane** due to knowledge of safe areas.  
  - To reflect this, a subset of agents (**leaders**) is introduced with **anticipation capabilities**, allowing them to predict the storm trajectory within a short time window. Leaders also exert a **stronger attraction influence**, guiding the group towards safe areas.


## Simulations  

Computational experiments simulated the movement of a macaque group in response to a modeled tornado on Cayo Santiago. The results highlighted the **critical role of leadership and anticipatory behaviour** in ensuring group survival. Simulations confirmed that **mortality rates significantly increase when leader anticipation is absent**, demonstrating the importance of informed decision-making during extreme events.  

### **Results (GIFs of Simulations)**  
<table>
  <tr>
    <td align="center">
      <img src="supplementary_material/simulation_0leaders.gif" width="100%">
      <p><em>Simulation of macaques responding to an approaching storm and without leader anticipation.</em></p>
    </td>
    <td align="center">
      <img src="supplementary_material/simulation_10leaders.gif" width="100%">
      <p><em>Comparison of survival outcomes with 10 leaders with anticipation.</em></p>
    </td>
  </tr>
</table>


