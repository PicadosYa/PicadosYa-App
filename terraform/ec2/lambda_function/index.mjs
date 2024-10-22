import AWS from "aws-sdk";
const ec2 = new AWS.EC2();
const sns = new AWS.SNS();

const getInstanceIds = async () => {
  try {
    const params = {
      Filters: [
        {
          Name: "tag:ec2-scheduled",
          Values: ["true"],
        },
      ],
    };

    const result = await ec2.describeInstances(params).promise();
    const instanceIds = [];

    result.Reservations.forEach((reservation) => {
      reservation.Instances.forEach((instance) => {
        console.log("Instance: ", instance.InstanceId);
        const nameTag = instance.Tags.find((tag) => tag.Key === "Name");
        if (nameTag && nameTag.Value.includes("ec2-scheduled")) {
          instanceIds.push({ id: instance.InstanceId, name: nameTag.Value });
        }
      });
    });

    return instanceIds;
  } catch (error) {
    console.error(`Error al obtener las instancias: ${error.message}`, error);
    throw new Error(`No se pudieron obtener las instancias: ${error.message}`);
  }
};

const sendSNSNotification = async (message) => {
  const snsTopicArn = process.env.SNS_TOPIC_ARN;
  const params = {
    Message: message,
    TopicArn: snsTopicArn,
  };

  try {
    await sns.publish(params).promise();
    console.log(`Mensaje enviado a SNS: ${message}`);
  } catch (error) {
    console.error(`Error al enviar mensaje a SNS: ${error.message}`);
    throw new Error(`No se pudo enviar mensaje a SNS: ${error.message}`);
  }
};

export const handler = async (event) => {
  const action = event.action;
  const instanceData = await getInstanceIds();

  console.log(
    `Acción solicitada: ${action} para instancias: ${instanceData
      .map((instance) => instance.name)
      .join(", ")}`
  );

  try {
    if (action === "start") {
      await startInstances(instanceData.map((instance) => instance.id));
      for (const instance of instanceData) {
        await sendSNSNotification(`Instancia ${instance.name} iniciada.`);
      }
    } else if (action === "stop") {
      await stopInstances(instanceData.map((instance) => instance.id));
      for (const instance of instanceData) {
        await sendSNSNotification(`Instancia ${instance.name} detenida.`);
      }
    } else {
      throw new Error(`Acción inválida: ${action}`);
    }
    return {
      statusCode: 200,
      body: JSON.stringify(
        `Acción ${action} ejecutada en las instancias: ${instanceData
          .map((instance) => instance.name)
          .join(", ")}`
      ),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: error.message }),
    };
  }
};

const startInstances = async (instanceIds) => {
  if (instanceIds.length > 0) {
    await ec2.startInstances({ InstanceIds: instanceIds }).promise();
    console.log(`Iniciando instancias: ${instanceIds}`);
  } else {
    console.log("No hay instancias para iniciar.");
  }
};

const stopInstances = async (instanceIds) => {
  if (instanceIds.length > 0) {
    await ec2.stopInstances({ InstanceIds: instanceIds }).promise();
    console.log(`Deteniendo instancias: ${instanceIds}`);
  } else {
    console.log("No hay instancias para detener.");
  }
};
